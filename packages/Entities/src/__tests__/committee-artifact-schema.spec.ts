import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { BaseEntity, RunView } from '@memberjunction/core';
import { MJGlobal } from '@memberjunction/global';
import {
    mjBizAppsCommitteesArtifactSchema,
    mjBizAppsCommitteesAttendanceSchema,
    mjBizAppsCommitteesMinuteSchema,
    mjBizAppsCommitteesMotionSchema,
    mjBizAppsCommitteesVoteSchema,
    MinuteEntityCustom,
    LoadCustomMinuteEntity,
} from '../index';

const ARTIFACT_ID_A = '11111111-1111-4111-8111-111111111111';
const ARTIFACT_ID_B = '22222222-2222-4222-8222-222222222222';
const VERSION_ID_1 = '33333333-3333-4333-8333-333333333333';

interface MockMinuteFields {
    MJArtifactID: string | null;
    ApprovedArtifactVersionID: string | null;
    Content: string | null;
}

function createMockMinute(fields: MockMinuteFields): MinuteEntityCustom {
    const instance = Object.create(MinuteEntityCustom.prototype) as MinuteEntityCustom;
    Object.defineProperty(instance, 'MJArtifactID', { get: () => fields.MJArtifactID, configurable: true });
    Object.defineProperty(instance, 'ApprovedArtifactVersionID', {
        get: () => fields.ApprovedArtifactVersionID,
        configurable: true,
    });
    Object.defineProperty(instance, 'Content', { get: () => fields.Content, configurable: true });
    Object.defineProperty(instance, 'ProviderToUse', { get: () => null, configurable: true });
    Object.defineProperty(instance, 'ContextCurrentUser', { get: () => undefined, configurable: true });
    return instance;
}

describe('Committees MJ Docs additive schema & entity parity', () => {
    it('exposes nullable MJArtifactID and ApprovedArtifactVersionID on Minute schema while preserving Content and ArtifactID', () => {
        const shape = mjBizAppsCommitteesMinuteSchema.shape;
        expect(shape).toHaveProperty('MJArtifactID');
        expect(shape).toHaveProperty('ApprovedArtifactVersionID');
        expect(shape).toHaveProperty('Content');
        expect(shape).toHaveProperty('ArtifactID');
        expect(shape).toHaveProperty('ApprovalStatus');

        expect(shape.MJArtifactID.safeParse(null).success).toBe(true);
        expect(shape.MJArtifactID.safeParse(ARTIFACT_ID_A).success).toBe(true);
        expect(shape.ApprovedArtifactVersionID.safeParse(null).success).toBe(true);
        expect(shape.ApprovedArtifactVersionID.safeParse(VERSION_ID_1).success).toBe(true);
        expect(shape.Content.safeParse('Legacy markdown content').success).toBe(true);
    });

    it('exposes nullable MJArtifactID on Committees: Artifacts schema while preserving external URL fields', () => {
        const shape = mjBizAppsCommitteesArtifactSchema.shape;
        expect(shape).toHaveProperty('MJArtifactID');
        expect(shape).toHaveProperty('URL');
        expect(shape).toHaveProperty('Provider');
        expect(shape).toHaveProperty('ExternalID');

        expect(shape.MJArtifactID.safeParse(null).success).toBe(true);
        expect(shape.MJArtifactID.safeParse(ARTIFACT_ID_A).success).toBe(true);
        expect(shape.URL.safeParse('https://drive.google.com/file/d/abc').success).toBe(true);
    });

    it('keeps Motion, Vote, and Attendance notes strictly relational (Category C)', () => {
        expect(mjBizAppsCommitteesMotionSchema.shape).toHaveProperty('Notes');
        expect(mjBizAppsCommitteesMotionSchema.shape).not.toHaveProperty('MJArtifactID');

        expect(mjBizAppsCommitteesVoteSchema.shape).toHaveProperty('Notes');
        expect(mjBizAppsCommitteesVoteSchema.shape).not.toHaveProperty('MJArtifactID');

        expect(mjBizAppsCommitteesAttendanceSchema.shape).toHaveProperty('Notes');
        expect(mjBizAppsCommitteesAttendanceSchema.shape).not.toHaveProperty('MJArtifactID');
    });

    it('registers MinuteEntityCustom under Committees: Minutes in MJGlobal ClassFactory', () => {
        LoadCustomMinuteEntity();
        const registration = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Minutes');
        expect(registration?.SubClass).toBe(MinuteEntityCustom);
    });
});

describe('MinuteEntityCustom validation invariants', () => {
    let baseValidateSpy: ReturnType<typeof vi.spyOn>;
    let baseValidateAsyncSpy: ReturnType<typeof vi.spyOn>;

    beforeEach(() => {
        baseValidateSpy = vi.spyOn(BaseEntity.prototype, 'Validate').mockReturnValue({
            Success: true,
            Errors: [],
        });
        baseValidateAsyncSpy = vi.spyOn(BaseEntity.prototype, 'ValidateAsync').mockResolvedValue({
            Success: true,
            Errors: [],
        });
    });

    afterEach(() => {
        baseValidateSpy.mockRestore();
        baseValidateAsyncSpy.mockRestore();
        vi.restoreAllMocks();
    });

    it('accepts legacy minutes with Content and null MJArtifactID/ApprovedArtifactVersionID', () => {
        const minute = createMockMinute({
            MJArtifactID: null,
            ApprovedArtifactVersionID: null,
            Content: '# Legacy Meeting Minutes',
        });

        const res = minute.Validate();
        expect(res.Success).toBe(true);
        expect(res.Errors).toHaveLength(0);
    });

    it('rejects setting ApprovedArtifactVersionID when MJArtifactID is null', () => {
        const minute = createMockMinute({
            MJArtifactID: null,
            ApprovedArtifactVersionID: VERSION_ID_1,
            Content: null,
        });

        const res = minute.Validate();
        expect(res.Success).toBe(false);
        expect(res.Errors.some((e) => e.Source === 'ApprovedArtifactVersionID')).toBe(true);
    });

    it('rejects malformed UUIDs on MJArtifactID and ApprovedArtifactVersionID', () => {
        const minute = createMockMinute({
            MJArtifactID: 'not-a-uuid',
            ApprovedArtifactVersionID: 'also-invalid',
            Content: null,
        });

        const res = minute.Validate();
        expect(res.Success).toBe(false);
        expect(res.Errors.map((e) => e.Source)).toEqual(
            expect.arrayContaining(['MJArtifactID', 'ApprovedArtifactVersionID'])
        );
    });

    it('passes ValidateAsync when ApprovedArtifactVersionID belongs to MJArtifactID', async () => {
        const runViewMock = vi.fn().mockResolvedValue({
            Success: true,
            Results: [{ ID: VERSION_ID_1, ArtifactID: ARTIFACT_ID_A }],
        });
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunView: runViewMock,
        } as Partial<RunView> as RunView);

        const minute = createMockMinute({
            MJArtifactID: ARTIFACT_ID_A,
            ApprovedArtifactVersionID: VERSION_ID_1,
            Content: null,
        });

        const res = await minute.ValidateAsync();
        expect(res.Success).toBe(true);
        expect(res.Errors).toHaveLength(0);
        expect(runViewMock).toHaveBeenCalledTimes(1);
    });

    it('fails ValidateAsync when ApprovedArtifactVersionID belongs to a different ArtifactID', async () => {
        const runViewMock = vi.fn().mockResolvedValue({
            Success: true,
            Results: [{ ID: VERSION_ID_1, ArtifactID: ARTIFACT_ID_B }],
        });
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunView: runViewMock,
        } as Partial<RunView> as RunView);

        const minute = createMockMinute({
            MJArtifactID: ARTIFACT_ID_A,
            ApprovedArtifactVersionID: VERSION_ID_1,
            Content: null,
        });

        const res = await minute.ValidateAsync();
        expect(res.Success).toBe(false);
        expect(res.Errors[0]?.Message).toContain('must belong to the linked MJArtifactID');
    });

    it('fails ValidateAsync when ApprovedArtifactVersionID does not exist', async () => {
        const runViewMock = vi.fn().mockResolvedValue({
            Success: true,
            Results: [],
        });
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunView: runViewMock,
        } as Partial<RunView> as RunView);

        const minute = createMockMinute({
            MJArtifactID: ARTIFACT_ID_A,
            ApprovedArtifactVersionID: VERSION_ID_1,
            Content: null,
        });

        const res = await minute.ValidateAsync();
        expect(res.Success).toBe(false);
        expect(res.Errors[0]?.Message).toContain('does not exist');
    });
});
