---
"@mj-biz-apps/committees-entities": minor
"@mj-biz-apps/committees-server": minor
"@mj-biz-apps/committees-ng": minor
---

Add predictive meeting quorum risk outcome columns, layered base views (vwMeetingsGenerated and vwMeetings), and scoring binding write-back.

- Materializes `PredictedQuorumRiskProbability`, `PredictedQuorumRiskBand`, and `PredictedQuorumRiskScoredAt` on `Meeting`.
- Updates layered base view `vwMeetings` to compute engineered quorum features (`QuorumRiskOutcome`, `MeetingDurationMinutes`, `DaysUntilMeeting`, `IsVirtualFlag`, `IsHybridFlag`, `IsInPersonFlag`, `HasVideoLink`, `AgendaItemCount`, `TotalAttendees`, `ExpectedAttendees`, `PresentAttendees`, `AbsentAttendees`).
- Configures ML training pipeline, model candidates (XGBoost, LightGBM, Random Forest), and scheduled scoring binding targeting `PredictedQuorumRiskProbability`.
