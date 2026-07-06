/** @type {import('@memberjunction/config').MJConfig} */
module.exports = {
  /**
   * MemberJunction v3.0 Minimal Distribution Configuration
   *
   * This config leverages the minimal configuration system where most settings
   * come from package defaults:
   * - Database settings → Environment variables (via config schema defaults)
   * - CodeGen settings → DEFAULT_CODEGEN_CONFIG (@memberjunction/codegen-lib)
   *
   * You only need to specify:
   * 1. Environment variables in .env file (database, auth)
   * 2. Deployment-specific settings (output paths, commands) - BELOW
   * 3. Any settings you want to override from the defaults
   */

  // ============================================================================
  // DEPLOYMENT-SPECIFIC CONFIGURATION (Required)
  // ============================================================================

  /**
   * Output paths for code generation
   * These are specific to this distribution's directory structure
   */
  /**
   * Schema-to-package mapping for entity imports in generated code.
   * Each schema maps to the npm package that provides its entity classes.
   * Schemas not listed here use the default 'mj_generatedentities' package.
   */
  entityPackageName: '@mj-biz-apps/committees-entities',

  output: [
    { type: 'SQL', directory: './SQL Scripts/generated', appendOutputCode: true },
    {
      // Generated Angular entity forms live in the publishable ng package (not the
      // MJExplorer host app) so `mj app install` consumers get them — matches bizapps-tasks.
      type: 'Angular',
      directory: './packages/Angular/src/lib/generated',
      options: [{ name: 'maxComponentsPerModule', value: 20 }],
    },
    // Generated GraphQL resolvers ship inside committees-server for the same reason.
    { type: 'GraphQLServer', directory: './packages/Server/src/generated' },
    { type: 'ActionSubclasses', directory: './packages/Actions/src/generated' },
    { type: 'EntitySubclasses', directory: './packages/GeneratedEntities/src/generated' },
    { type: 'DBSchemaJSON', directory: './Schema Files' },
  ],

  /**
   * Build commands to run after code generation
   * These are specific to this distribution's package structure
   */
  commands: [
    {
      workingDirectory: './packages/GeneratedEntities',
      command: 'npm',
      args: ['run', 'build'],
      when: 'after',
    },
    {
      workingDirectory: './packages/Actions',
      command: 'npm',
      args: ['run', 'build'],
      when: 'after',
    },
    {
      workingDirectory: './apps/MJAPI',
      command: 'npm',
      args: ['start'],
      timeout: 30000,
      when: 'after',
    },
  ],

  // Open App engine workspace paths — the engine defaults to packages/MJAPI and
  // packages/MJExplorer; our host apps live under apps/ (matches bizapps-accounting).
  openApps: {
    serverPackagePath: 'apps/MJAPI',
    clientPackagePath: 'apps/MJExplorer',
  },

  // ============================================================================
  // OPTIONAL OVERRIDES
  // ============================================================================
  // Everything below this line is OPTIONAL. These settings have sensible defaults
  // in DEFAULT_SERVER_CONFIG and DEFAULT_CODEGEN_CONFIG.
  //
  // Uncomment and modify only if you need to override the defaults.
  // ============================================================================

  // ---------------------------------------------------------------------------
  // CodeGen Settings Overrides
  // ---------------------------------------------------------------------------
  // Default: [
  //   { name: 'mj_core_schema', value: '__mj' },
  //   { name: 'skip_database_generation', value: false },
  //   { name: 'recompile_mj_views', value: true },
  //   { name: 'auto_index_foreign_keys', value: true },
  // ]
  // settings: [
  //   { name: 'mj_core_schema', value: '__mj' },
  //   { name: 'skip_database_generation', value: false },
  //   { name: 'recompile_mj_views', value: true },
  //   { name: 'auto_index_foreign_keys', value: true },
  // ],

  // ---------------------------------------------------------------------------
  // Logging Overrides
  // ---------------------------------------------------------------------------
  // Default: { log: true, logFile: 'codegen.output.log', console: true }
  // logging: {
  //   log: true,
  //   logFile: 'codegen.output.log',
  //   console: true,
  // },

  // ---------------------------------------------------------------------------
  // New Entity Defaults Overrides
  // ---------------------------------------------------------------------------
  // Default v3.x settings for new entities
  newEntityDefaults: {
    NameRulesBySchema: [
      { SchemaName: '${mj_core_schema}', EntityNamePrefix: 'MJ: ' },
      {
        SchemaName: '__mj_BizAppsCommittees',
        EntityNamePrefix: 'Committees: ',
        EntityNameSuffix: '',
      },
    ],
  },

  // ---------------------------------------------------------------------------
  // Schema/Table Exclusions
  // ---------------------------------------------------------------------------
  // Default: excludeSchemas: ['sys', 'staging', '__mj']
  // Default: excludeTables: [{ schema: '%', table: 'sys%' }, { schema: '%', table: 'flyway_schema_history' }]
  //
  // We exclude the BizAppsCommon and BizAppsTasks schemas because those entities are owned
  // and generated by their respective sibling repos (bizapps-common, bizapps-tasks). The
  // committees repo only owns its own __mj_BizAppsCommittees schema.
  excludeSchemas: ['sys', 'staging', 'dbo', '__mj', '__mj_BizAppsCommon', '__mj_BizAppsTasks'],
  // excludeTables: [
  //   { schema: '%', table: 'sys%' },
  //   { schema: '%', table: 'flyway_schema_history' }
  // ],

  // ---------------------------------------------------------------------------
  // AI-Powered Advanced Generation Features
  // ---------------------------------------------------------------------------
  // Default v3.x: Several features enabled by default
  // advancedGeneration: {
  //   enableAdvancedGeneration: true,
  //   features: [
  //     { name: 'EntityNames', enabled: false },
  //     { name: 'DefaultInViewFields', enabled: true },
  //     { name: 'EntityDescriptions', enabled: false },
  //     { name: 'SmartFieldIdentification', enabled: true },
  //     { name: 'TransitiveJoinIntelligence', enabled: true },
  //     { name: 'FormLayoutGeneration', enabled: true },
  //     { name: 'ParseCheckConstraints', enabled: true },
  //   ],
  // },

  // ---------------------------------------------------------------------------
  // SQL Output (for migrations)
  // ---------------------------------------------------------------------------
  // schemaPlaceholders drives flyway placeholder resolution at migrate time:
  //   ${flyway:defaultSchema} -> __mj_BizAppsCommittees (this repo's app schema)
  //   ${mjSchema}             -> __mj                   (MJ core schema)
  //   ${mjBACSchema}          -> __mj_BizAppsCommon
  // Migrations must use ${mjSchema} for core MJ tables (File, Entity, etc.),
  // NOT ${flyway:defaultSchema} which points at our own schema.
  // Order matters: more-specific schemas must come first because substitution
  // runs sequentially with a greedy regex — '__mj' listed first would also match
  // the '__mj' prefix of '__mj_BizAppsCommittees'.
  SQLOutput: {
    enabled: true,
    folderPath: './migrations/codegen/',
    appendToFile: false,
    convertCoreSchemaToFlywayMigrationFile: true,
    omitRecurringScriptsFromLog: false,
    schemaPlaceholders: [
      { schema: '__mj_BizAppsCommittees', placeholder: '${flyway:defaultSchema}' },
      { schema: '__mj_BizAppsCommon', placeholder: '${mjBACSchema}' },
      { schema: '__mj', placeholder: '${mjSchema}' },
    ],
  },

  // ---------------------------------------------------------------------------
  // Force Regeneration Options
  // ---------------------------------------------------------------------------
  // Default: All false (only regenerate on schema changes)
  // forceRegeneration: {
  //   enabled: false,
  //   baseViews: false,
  //   spCreate: false,
  //   spUpdate: false,
  //   spDelete: false,
  //   allStoredProcedures: false,
  //   indexes: false,
  //   fullTextSearch: false,
  // },

  // ---------------------------------------------------------------------------
  // Database Connection Overrides
  // ---------------------------------------------------------------------------
  // These come from DEFAULT_SERVER_CONFIG with environment variable defaults
  dbHost: process.env.DB_HOST ?? 'localhost',
  dbPort: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 1433,
  dbDatabase: process.env.DB_DATABASE,
  dbUsername: process.env.DB_USERNAME,
  dbPassword: process.env.DB_PASSWORD,
  codeGenLogin: process.env.CODEGEN_DB_USERNAME,
  codeGenPassword: process.env.CODEGEN_DB_PASSWORD,

  // ---------------------------------------------------------------------------
  // Server Settings Overrides
  // ---------------------------------------------------------------------------
  // These come from DEFAULT_SERVER_CONFIG
  // graphqlPort: process.env.GRAPHQL_PORT ?? 4000,
  // mjCoreSchema: process.env.MJ_CORE_SCHEMA ?? '__mj',

  // ---------------------------------------------------------------------------
  // Database Settings — pool tuned for local Docker SQL Server.
  //
  // MJ 5.29's BaseAIEngine fans out 36 parallel RunView calls at startup. With
  // the default min:5 pool, 31 of those 36 queries trigger fresh TCP handshakes
  // simultaneously through Docker Desktop's network bridge — which on macOS
  // adds 200-500ms per new connection. That cascade lands us in 30s timeouts.
  //
  // Setting min:30 keeps 30 connections always-warm so concurrent startup
  // queries can grab them without re-handshaking. Bumped requestTimeout
  // from 30s to 60s as a defensive backstop in case the warm-up hasn't
  // finished by the time the engines fire.
  // ---------------------------------------------------------------------------
  databaseSettings: {
    connectionTimeout: 45000,
    requestTimeout: 60000,
    connectionPool: {
      max: 50,
      min: 30,
      idleTimeoutMillis: 30000,
      acquireTimeoutMillis: 30000,
    },
  },
};
