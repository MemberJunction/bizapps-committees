import {
    Component, EventEmitter, Input, Output, OnInit,
    ChangeDetectionStrategy, ChangeDetectorRef, inject
} from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { Metadata } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { marked } from 'marked';

export type MinutesPanelState = 'input' | 'generating' | 'preview' | 'editing';

const GENERATE_MINUTES_MUTATION = `
    mutation GenerateMeetingMinutes($input: GenerateMinutesInput!) {
        GenerateMeetingMinutes(input: $input) {
            Success
            ErrorMessage
            MeetingID
            Content
        }
    }
`;

@Component({
    standalone: false,
    selector: 'generate-minutes-panel',
    templateUrl: './generate-minutes-panel.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './generate-minutes-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class GenerateMinutesPanelComponent implements OnInit {
    @Input() MeetingID!: string;
    @Input() TranscriptURL: string | null = null;
    @Output() Close = new EventEmitter<void>();

    State: MinutesPanelState = 'input';
    TranscriptSource: 'paste' | 'url' | 'meeting-url' | 'none' = 'paste';
    TranscriptText = '';
    TranscriptURL_Input = '';
    GeneratedContent = '';
    ErrorMessage = '';
    CopySuccess = false;

    private cdr = inject(ChangeDetectorRef);
    private sanitizer = inject(DomSanitizer);

    ngOnInit(): void {
        if (this.TranscriptURL) {
            this.TranscriptSource = 'meeting-url';
        }
    }

    get RenderedContent(): SafeHtml {
        const html = marked.parse(this.GeneratedContent) as string;
        return this.sanitizer.bypassSecurityTrustHtml(html);
    }

    async OnGenerate(): Promise<void> {
        this.State = 'generating';
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        try {
            const transcript = this.resolveTranscriptInput();
            const content = await this.callGenerateMutation(transcript);
            this.GeneratedContent = content;
            this.State = 'preview';
        } catch (error) {
            this.ErrorMessage = error instanceof Error ? error.message : String(error);
            this.State = 'input';
        }

        this.cdr.markForCheck();
    }

    async OnCopyToClipboard(): Promise<void> {
        await navigator.clipboard.writeText(this.GeneratedContent);
        this.CopySuccess = true;
        this.cdr.markForCheck();
        setTimeout(() => {
            this.CopySuccess = false;
            this.cdr.markForCheck();
        }, 2000);
    }

    OnToggleEdit(): void {
        this.State = this.State === 'preview' ? 'editing' : 'preview';
        this.cdr.markForCheck();
    }

    OnClose(): void {
        this.Close.emit();
    }

    /**
     * Returns the transcript to send. For 'paste' returns the text directly.
     * For 'url' or 'meeting-url' returns null so the server fetches it via
     * Meeting.TranscriptURL or the user-supplied URL embedded in the mutation input.
     */
    private resolveTranscriptInput(): string | null {
        if (this.TranscriptSource === 'paste') return this.TranscriptText.trim() || null;
        return null;
    }

    private resolveTranscriptURL(): string | null {
        if (this.TranscriptSource === 'url') return this.TranscriptURL_Input.trim() || null;
        if (this.TranscriptSource === 'meeting-url') return this.TranscriptURL;
        return null;
    }

    private async callGenerateMutation(transcript: string | null): Promise<string> {
        const provider = Metadata.Provider as GraphQLDataProvider;
        const transcriptURL = this.resolveTranscriptURL();
        const input: { MeetingID: string; Transcript?: string; TranscriptURL?: string } = { MeetingID: this.MeetingID };
        if (transcript) input.Transcript = transcript;
        if (transcriptURL) input.TranscriptURL = transcriptURL;

        const result = await provider.ExecuteGQL(GENERATE_MINUTES_MUTATION, { input });
        const data = result?.GenerateMeetingMinutes;

        if (!data?.Success) {
            throw new Error(data?.ErrorMessage ?? 'Unknown error generating minutes');
        }

        return data.Content as string;
    }
}

export function LoadGenerateMinutesPanel(): void { /* tree-shaking prevention */ }
