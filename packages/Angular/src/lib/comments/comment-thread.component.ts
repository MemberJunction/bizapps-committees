import {
    Component,
    Input,
    OnInit,
    ChangeDetectionStrategy,
    ChangeDetectorRef,
    inject,
} from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjCommitteesCommentEntity } from '@mj-biz-apps/committees-entities';

interface CommentNode {
    Comment: mjCommitteesCommentEntity;
    Replies: CommentNode[];
    ShowReplyBox: boolean;
    ReplyText: string;
}

@Component({
    standalone: false,
    selector: 'comment-thread',
    templateUrl: './comment-thread.component.html',
    styleUrls: ['../shared/design-system.css', './comment-thread.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CommentThreadComponent implements OnInit {
    /** Required: committee ID for scoping */
    @Input() CommitteeID: string | null = null;

    /** Set exactly one of these to attach comments to an entity record */
    @Input() MeetingID: string | null = null;
    @Input() AgendaItemID: string | null = null;
    @Input() TaskID: string | null = null;
    @Input() ArtifactID: string | null = null;

    IsLoading = true;
    IsSaving = false;
    NewCommentText = '';
    CommentTree: CommentNode[] = [];
    TotalCount = 0;

    /** Auto-resolved from current MJ user → Person.LinkedUserID */
    CurrentPersonID: string | null = null;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.resolveCurrentPersonID(),
            this.LoadComments(),
        ]);
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    async LoadComments(): Promise<void> {
        const filter = this.buildFilter();
        if (!filter) return;

        const rv = new RunView();
        const result = await rv.RunView<mjCommitteesCommentEntity>({
            EntityName: 'Committees: Comments',
            ExtraFilter: filter,
            OrderBy: '__mj_CreatedAt ASC',
            ResultType: 'entity_object',
        });

        if (!result.Success) return;

        this.CommentTree = this.buildTree(result.Results);
        this.TotalCount = result.Results.length;
    }

    async OnPostComment(): Promise<void> {
        if (!this.NewCommentText.trim() || !this.CommitteeID || !this.CurrentPersonID) return;
        await this.saveComment(this.NewCommentText.trim(), null);
        this.NewCommentText = '';
    }

    async OnPostReply(node: CommentNode): Promise<void> {
        if (!node.ReplyText.trim() || !this.CommitteeID || !this.CurrentPersonID) return;
        await this.saveComment(node.ReplyText.trim(), node.Comment.ID);
        node.ReplyText = '';
        node.ShowReplyBox = false;
    }

    ToggleReply(node: CommentNode): void {
        node.ShowReplyBox = !node.ShowReplyBox;
        this.cdr.markForCheck();
    }

    async OnResolve(node: CommentNode): Promise<void> {
        node.Comment.IsResolved = !node.Comment.IsResolved;
        await node.Comment.Save();
        this.cdr.markForCheck();
    }

    FormatDate(date: Date): string {
        if (!(date instanceof Date) || isNaN(date.getTime())) return '';
        const now = new Date();
        const diffMs = now.getTime() - date.getTime();
        const diffMins = Math.floor(diffMs / 60000);
        if (diffMins < 1) return 'just now';
        if (diffMins < 60) return `${diffMins}m ago`;
        const diffHours = Math.floor(diffMins / 60);
        if (diffHours < 24) return `${diffHours}h ago`;
        const diffDays = Math.floor(diffHours / 24);
        if (diffDays < 7) return `${diffDays}d ago`;
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    }

    // -----------------------------------------------------------------------
    // Private helpers
    // -----------------------------------------------------------------------

    /**
     * Resolves current MJ user → Person via People.LinkedUserID
     */
    private async resolveCurrentPersonID(): Promise<void> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return;

        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID='${userID}'`,
            Fields: ['ID'],
            ResultType: 'simple',
            MaxRows: 1,
        });

        if (result.Success && result.Results.length > 0) {
            this.CurrentPersonID = result.Results[0].ID;
        }
    }

    private async saveComment(text: string, parentCommentID: string | null): Promise<void> {
        this.IsSaving = true;
        this.cdr.markForCheck();

        const md = new Metadata();
        const comment = await md.GetEntityObject<mjCommitteesCommentEntity>('Committees: Comments');
        comment.CommitteeID = this.CommitteeID!;
        comment.PersonID = this.CurrentPersonID!;
        comment.CommentText = text;

        if (parentCommentID) comment.ParentCommentID = parentCommentID;
        if (this.MeetingID) comment.MeetingID = this.MeetingID;
        if (this.AgendaItemID) comment.AgendaItemID = this.AgendaItemID;
        if (this.TaskID) comment.TaskID = this.TaskID;
        if (this.ArtifactID) comment.ArtifactID = this.ArtifactID;

        await comment.Save();

        this.IsSaving = false;
        await this.LoadComments();
        this.cdr.markForCheck();
    }

    private buildFilter(): string | null {
        if (!this.CommitteeID) return null;
        const parts = [`CommitteeID='${this.CommitteeID}'`];
        if (this.MeetingID) parts.push(`MeetingID='${this.MeetingID}'`);
        else parts.push('MeetingID IS NULL');
        if (this.AgendaItemID) parts.push(`AgendaItemID='${this.AgendaItemID}'`);
        else parts.push('AgendaItemID IS NULL');
        if (this.TaskID) parts.push(`TaskID='${this.TaskID}'`);
        else parts.push('TaskID IS NULL');
        if (this.ArtifactID) parts.push(`ArtifactID='${this.ArtifactID}'`);
        else parts.push('ArtifactID IS NULL');
        return parts.join(' AND ');
    }

    private buildTree(comments: mjCommitteesCommentEntity[]): CommentNode[] {
        const nodeMap = new Map<string, CommentNode>();
        const roots: CommentNode[] = [];

        for (const c of comments) {
            nodeMap.set(c.ID, { Comment: c, Replies: [], ShowReplyBox: false, ReplyText: '' });
        }

        for (const c of comments) {
            const node = nodeMap.get(c.ID)!;
            if (c.ParentCommentID && nodeMap.has(c.ParentCommentID)) {
                nodeMap.get(c.ParentCommentID)!.Replies.push(node);
            } else {
                roots.push(node);
            }
        }

        return roots;
    }
}

/** Tree-shaking prevention */
export function LoadCommentThread() { /* no-op */ }
