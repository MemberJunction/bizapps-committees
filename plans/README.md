# Committees Application: Planning Documents

**Last Updated:** September 26, 2026

---

## Document Index

### 🧩 [COLLABORATION_REBUILD_PLAN.md](./COLLABORATION_REBUILD_PLAN.md)
**Committees on Collaboration** - How Committees becomes a plug-in on bizapps-collaboration:
- Committee and Term extend Collaboration's Space through IsA
- Seats synced from memberships; sub-committees keep their own membership
- The space types, drivers, contributions and tests Committees ships
- The data migration, and why it's Committees 2.0.0

**Status:** 📝 Planned - starts after bizapps-collaboration is done

---

### 📘 [COMPREHENSIVE_DESIGN.md](./COMPREHENSIVE_DESIGN.md)
**The primary design document** - Contains everything you need to build the Committees application:
- Executive summary and market positioning
- Complete data model (all entities with SQL)
- MJ infrastructure usage (security, notifications, RBAC)
- Integration architecture (Google, Microsoft, Box)
- Feature specifications (Phase 1, 2, 3)
- Implementation timeline
- UX design overview (links to mockups)

**Status:** ✅ Complete and Active

---

### 📊 [MARKET_RESEARCH_REPORT.md](./MARKET_RESEARCH_REPORT.md)
**120-page market analysis** - Deep dive into committee management market:
- Competitive landscape (Boardable, Diligent, BoardEffect, AMS platforms)
- Association-specific requirements
- Table-stakes features vs. differentiators
- Pain points and gaps in current solutions
- Best practices for committee governance
- Pricing analysis and recommendations

**Status:** ✅ Complete - Reference for market validation

---

### 📋 [PLAN_ENHANCEMENT_RECOMMENDATIONS.md](./PLAN_ENHANCEMENT_RECOMMENDATIONS.md)
**Comparison and gap analysis** - Maps market research to design:
- Current plan vs. market requirements
- Critical gaps for Phase 1 (table stakes)
- Recommended phasing (1A, 1B, 2, 3)
- New entity definitions (Vote, Comment, Charter, etc.)
- Feature prioritization matrix

**Status:** ✅ Complete - Incorporated into COMPREHENSIVE_DESIGN.md

---

### 📐 [committees-design.md](./committees-design.md)
**Original design document** - Initial Phase 1 plan:
- Business overview and personas
- 10 core entities (original schema)
- ERD diagrams
- Seed data

**Status:** 📦 Archived - Superseded by COMPREHENSIVE_DESIGN.md

---

### 🎨 [mockups/](./mockups/)
**UX design mockups** - Visual designs for all user journeys:
- 10 key user journeys (committee setup, meetings, elections, etc.)
- 3 design options per journey (Minimal, Functional, Modern)
- Refinement and final approved designs

**Status:** 🚧 In Progress - See [mockups/README.md](./mockups/README.md)

---

## Quick Start Guide

### For Developers:
1. **Read:** [COMPREHENSIVE_DESIGN.md](./COMPREHENSIVE_DESIGN.md) - Understand the full scope
2. **Review:** [Data Model section](./COMPREHENSIVE_DESIGN.md#data-model) - Database schema
3. **Study:** [MJ Infrastructure section](./COMPREHENSIVE_DESIGN.md#memberjunction-infrastructure) - Leverage existing MJ capabilities
4. **Implement:** Follow [Phase 1 plan](./COMPREHENSIVE_DESIGN.md#implementation-phases)

### For Product/UX:
1. **Read:** [Market Research](./MARKET_RESEARCH_REPORT.md) - Understand user needs
2. **Review:** [Feature Specs](./COMPREHENSIVE_DESIGN.md#feature-specifications) - What we're building
3. **Design:** [Mockups](./mockups/) - Create visual designs
4. **Validate:** Test with beta users

### For Stakeholders:
1. **Read:** [Executive Summary](./COMPREHENSIVE_DESIGN.md#executive-summary)
2. **Review:** [Market Positioning](./COMPREHENSIVE_DESIGN.md#market-positioning)
3. **Understand:** [Success Metrics](./COMPREHENSIVE_DESIGN.md#success-metrics)
4. **Track:** [Implementation Phases](./COMPREHENSIVE_DESIGN.md#implementation-phases)

---

## Key Decisions

### ✅ Approved:
- **Technology:** MemberJunction 5.0 platform, TypeScript, Angular 18, SQL Server
- **Dependencies:** BizApps Common for Person/Organization entities
- **Integrations:** Google Workspace, Microsoft 365, Box.com (not proprietary storage)
- **AI:** MJ AI Framework with Claude 4 for minute generation
- **Security:** MJ field encryption, RBAC, audit logging (not custom)
- **Notifications:** MJ NotificationEngine (not custom)
- **Pricing:** $199-999/month tiered by committee count, unlimited users

### 🎯 Target Market:
1. **Primary (60%):** Professional associations, standards bodies
2. **Secondary (30%):** Nonprofits with multiple committees
3. **Tertiary (10%):** Mid-market corporate boards

### 📆 Timeline:
- **Phase 1:** Days to weeks (core foundation with AI-assisted development)
- **Phase 2:** Weeks after Phase 1 (AI features, voting, collaboration)
- **Phase 3:** Weeks to months (elections, standards, governance)

---

## Next Steps

### Immediate:
1. ✅ Comprehensive design document completed
2. ✅ Mockup directory structure created
3. 🚧 **Begin UX mockups** - 3 options per journey
4. ⬜ Review and refine mockups with stakeholders
5. ⬜ Begin Phase 1 implementation

### Week 1-2:
1. Run database migrations (BizApps + Committees)
2. Run CodeGen to generate entities
3. Set up RBAC, encryption, notifications
4. Build core services (Committee, Meeting, ActionItem)

### Week 3-4:
1. Implement Angular UI components
2. Build integrations (Google, Microsoft, Zoom)
3. Test end-to-end workflows
4. Launch beta with 5-10 customers

---

## Document Maintenance

**Primary Document:** [COMPREHENSIVE_DESIGN.md](./COMPREHENSIVE_DESIGN.md)
- **Owner:** Development Team
- **Update Frequency:** As features are implemented
- **Version:** 2.0 (February 15, 2026)

**Market Research:** [MARKET_RESEARCH_REPORT.md](./MARKET_RESEARCH_REPORT.md)
- **Owner:** Product Team
- **Update Frequency:** Quarterly or when market shifts
- **Version:** 1.0 (February 15, 2026)

**UX Mockups:** [mockups/](./mockups/)
- **Owner:** Design Team
- **Update Frequency:** Continuously during design phase
- **Status:** In Progress

---

## Questions or Feedback?

- **Technical Questions:** Refer to [COMPREHENSIVE_DESIGN.md](./COMPREHENSIVE_DESIGN.md)
- **Market/Product Questions:** Refer to [MARKET_RESEARCH_REPORT.md](./MARKET_RESEARCH_REPORT.md)
- **Design Questions:** Refer to [mockups/README.md](./mockups/README.md)

---

**Planning Team:**
- Development: Build on MJ 5.0 platform
- Product: Define features based on market research
- Design: Create world-class UX with 3 options per journey
- Stakeholders: Review and approve phases

**Last Review:** February 15, 2026
**Next Review:** After Phase 1 completion
