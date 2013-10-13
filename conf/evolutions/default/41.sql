# --- !Ups

ALTER TABLE simple_comment RENAME TO pull_request_comment;
DROP SEQUENCE IF EXISTS pull_request_comment_seq;
CREATE SEQUENCE pull_request_comment_seq START WITH simple_comment_seq.nextval;
DROP SEQUENCE IF EXISTS simple_comment_seq;
ALTER TABLE pull_request_comment ADD COLUMN project_id bigint;
ALTER TABLE pull_request_comment ADD COLUMN commit_a varchar(40);
ALTER TABLE pull_request_comment ADD COLUMN commit_b varchar(40);
ALTER TABLE pull_request_comment ADD COLUMN commit_id varchar(40);
ALTER TABLE pull_request_comment ADD COLUMN path varchar(255);
ALTER TABLE pull_request_comment ADD COLUMN line integer;
ALTER TABLE pull_request_comment ADD COLUMN side varchar(16);
ALTER TABLE pull_request_comment ADD COLUMN pull_request_id bigint;

ALTER TABLE code_comment RENAME TO commit_comment;
DROP SEQUENCE IF EXISTS commit_comment_seq;
CREATE SEQUENCE commit_comment_seq START WITH code_comment_seq.nextval;
DROP SEQUENCE IF EXISTS code_commit_seq;

ALTER TABLE notification_event DROP CONSTRAINT IF EXISTS ck_notification_event_resource_type;
ALTER TABLE notification_event ALTER COLUMN resource_type TYPE varchar(255);
UPDATE notification_event SET resource_type='COMMIT_COMMENT' WHERE resource_type='CODE_COMMENT';
UPDATE notification_event SET event_type='NEW_COMMIT_COMMENT' WHERE event_type='NEW_CODE_COMMENT';
UPDATE notification_event SET resource_type='PULL_REQUEST_COMMENT' WHERE resource_type='SIMPLE_COMMENT';
UPDATE notification_event SET event_type='NEW_PULL_REQUEST_COMMENT' WHERE event_type='NEW_SIMPLE_COMMENT';
ALTER TABLE notification_event ADD constraint ck_notification_event_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','COMMIT_COMMENT','PULL_REQUEST','PULL_REQUEST_COMMENT'));

ALTER TABLE watch DROP CONSTRAINT IF EXISTS ck_watch_resource_type;
ALTER TABLE watch ALTER COLUMN resource_type TYPE varchar(255);
UPDATE watch SET resource_type='COMMIT_COMMENT' WHERE resource_type='CODE_COMMENT';
UPDATE watch SET resource_type='PULL_REQUEST_COMMENT' WHERE resource_type='SIMPLE_COMMENT';
ALTER TABLE watch ADD CONSTRAINT ck_watch_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','COMMIT_COMMENT','PULL_REQUEST','PULL_REQUEST_COMMENT', 'COMMIT'));

ALTER TABLE unwatch DROP CONSTRAINT IF EXISTS ck_unwatch_resource_type;
ALTER TABLE unwatch ALTER COLUMN resource_type TYPE varchar(255);
UPDATE unwatch SET resource_type='COMMIT_COMMENT' WHERE resource_type='CODE_COMMENT';
UPDATE unwatch SET resource_type='PULL_REQUEST_COMMENT' WHERE resource_type='SIMPLE_COMMENT';
ALTER TABLE unwatch ADD CONSTRAINT ck_unwatch_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','COMMIT_COMMENT','PULL_REQUEST','PULL_REQUEST_COMMENT', 'COMMIT'));

ALTER TABLE issue_event DROP CONSTRAINT IF EXISTS ck_issue_event_event_type;
ALTER TABLE issue_event ALTER COLUMN event_type TYPE varchar(255);
UPDATE issue_event SET event_type='NEW_COMMIT_COMMENT' WHERE event_type='NEW_CODE_COMMENT';
UPDATE issue_event SET event_type='NEW_PULL_REQUEST_COMMENT' WHERE event_type='NEW_SIMPLE_COMMENT';
ALTER TABLE issue_event ADD CONSTRAINT ck_issue_event_event_type check (event_type in ('NEW_ISSUE','NEW_POSTING','ISSUE_ASSIGNEE_CHANGED','ISSUE_STATE_CHANGED','NEW_COMMENT','NEW_COMMIT_COMMENT','NEW_PULL_REQUEST','NEW_PULL_REQUEST_COMMENT','PULL_REQUEST_STATE_CHANGED','ISSUE_REFERRED'));

ALTER TABLE attachment DROP CONSTRAINT IF EXISTS ck_attachment_container_type;
UPDATE attachment SET container_type='COMMIT_COMMENT' WHERE container_type='CODE_COMMENT';
UPDATE attachment SET container_type='PULL_REQUEST_COMMENT' WHERE container_type='SIMPLE_COMMENT';
ALTER TABLE attachment ADD CONSTRAINT ck_attachment_container_type check (container_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','COMMIT_COMMENT', 'PULL_REQUEST_COMMENT', 'PULL_REQUEST'));

# --- !Downs

ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS project_id;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS commit_a;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS commit_b;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS commit_id;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS path;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS line;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS side;
ALTER TABLE pull_request_comment DROP COLUMN IF EXISTS pull_request_id;
ALTER TABLE pull_request_comment RENAME TO simple_comment;
DROP SEQUENCE IF EXISTS simple_comment_seq;
CREATE SEQUENCE simple_comment_seq START WITH pull_request_comment_seq.nextval;
DROP SEQUENCE IF EXISTS pull_request_comment_seq;

ALTER TABLE commit_comment RENAME TO code_comment;
DROP SEQUENCE IF EXISTS code_comment_seq;
CREATE SEQUENCE code_comment_seq START WITH commit_comment_seq.nextval;
DROP SEQUENCE IF EXISTS commit_comment_seq;

ALTER TABLE notification_event DROP CONSTRAINT IF EXISTS ck_notification_event_resource_type;
UPDATE notification_event SET resource_type='CODE_COMMENT' WHERE resource_type='COMMIT_COMMENT';
UPDATE notification_event SET event_type='NEW_CODE_COMMENT' WHERE event_type='NEW_COMMIT_COMMENT';
UPDATE notification_event SET resource_type='SIMPLE_COMMENT' WHERE resource_type='PULL_REQUEST_COMMENT';
UPDATE notification_event SET event_type='NEW_SIMPLE_COMMENT' WHERE event_type='NEW_PULL_REQUEST_COMMENT';
ALTER TABLE notification_event ADD constraint ck_notification_event_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','CODE_COMMENT','PULL_REQUEST','SIMPLE_COMMENT'));
ALTER TABLE notification_event ALTER COLUMN resource_type TYPE varchar(16);

ALTER TABLE watch DROP CONSTRAINT IF EXISTS ck_watch_resource_type;
UPDATE watch SET resource_type='CODE_COMMENT' WHERE resource_type='COMMIT_COMMENT';
UPDATE watch SET resource_type='SIMPLE_COMMENT' WHERE resource_type='PULL_REQUEST_COMMENT';
ALTER TABLE watch ADD CONSTRAINT ck_watch_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','CODE_COMMENT','PULL_REQUEST','SIMPLE_COMMENT', 'COMMIT'));
ALTER TABLE watch ALTER COLUMN resource_type TYPE varchar(16);

ALTER TABLE unwatch DROP CONSTRAINT IF EXISTS ck_unwatch_resource_type;
UPDATE unwatch SET resource_type='CODE_COMMENT' WHERE resource_type='COMMIT_COMMENT';
UPDATE unwatch SET resource_type='SIMPLE_COMMENT' WHERE resource_type='PULL_REQUEST_COMMENT';
ALTER TABLE unwatch ADD CONSTRAINT ck_unwatch_resource_type check (resource_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','LABEL','PROJECT_LABELS','FORK','CODE_COMMENT','PULL_REQUEST','SIMPLE_COMMENT', 'COMMIT'));
ALTER TABLE unwatch ALTER COLUMN resource_type TYPE varchar(16);

ALTER TABLE issue_event DROP CONSTRAINT IF EXISTS ck_issue_event_event_type;
UPDATE issue_event SET event_type='NEW_CODE_COMMENT' WHERE event_type='NEW_COMMIT_COMMENT';
UPDATE issue_event SET event_type='NEW_SIMPLE_COMMENT' WHERE event_type='NEW_PULL_REQUEST_COMMENT';
ALTER TABLE issue_event ADD constraint ck_issue_event_event_type check (event_type in ('NEW_ISSUE','NEW_POSTING','ISSUE_ASSIGNEE_CHANGED','ISSUE_STATE_CHANGED','NEW_COMMENT','NEW_PULL_REQUEST','NEW_SIMPLE_COMMENT','PULL_REQUEST_STATE_CHANGED', 'ISSUE_REFERRED'));
ALTER TABLE issue_event ALTER COLUMN event_type TYPE varchar(16);

ALTER TABLE attachment DROP CONSTRAINT IF EXISTS ck_attachment_container_type;
UPDATE attachment SET container_type='CODE_COMMENT' WHERE container_type='COMMIT_COMMENT';
UPDATE attachment SET container_type='SIMPLE_COMMENT' WHERE container_type='PULL_REQUEST_COMMENT';
ALTER TABLE attachment ADD CONSTRAINT ck_attachment_container_type check (container_type in ('ISSUE_POST','ISSUE_ASSIGNEE','ISSUE_STATE','ISSUE_CATEGORY','ISSUE_MILESTONE','ISSUE_LABEL','BOARD_POST','BOARD_CATEGORY','BOARD_NOTICE','CODE','MILESTONE','WIKI_PAGE','PROJECT_SETTING','SITE_SETTING','USER','USER_AVATAR','PROJECT','ATTACHMENT','ISSUE_COMMENT','NONISSUE_COMMENT','CODE_COMMENT', 'PULL_REQUEST'));
