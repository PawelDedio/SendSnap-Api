USER_NAME_MIN_LENGTH = 3
USER_NAME_MAX_LENGTH = 15
USER_DISPLAY_NAME_MIN_LENGTH = 3
USER_DISPLAY_NAME_MAX_LENGTH = 30
USER_ROLE_ADMIN = 'admin'
USER_ROLE_USER = 'user'

HEADER_AUTH_TOKEN = 'Authorization'

AUTH_TOKEN_TIME_LENGTH = 1.month.from_now

COLLECTION_LABEL = 'collection'
DEFAULT_PAGE_SIZE = 999999
MINIMUM_PAGE_SIZE = 1
MAXIMUM_PAGE_SIZE = 999999

DEFAULT_SORT_BY = :created_at
DEFAULT_SORT_ORDER = :asc

SNAP_TYPE_PHOTO = 'photo'
SNAP_TYPE_VIDEO = 'video'

ANDROID_DEVICE = 'android'

NOTIFICATION_INVITATION_RECEIVED = 'invitation_received'
NOTIFICATION_INVITATION_ACCEPTED = 'invitation_accepted'
NOTIFICATION_INVITATION_REJECTED = 'invitation_rejected'

NOTIFICATION_SNAP_RECEIVED = 'snap_received'
NOTIFICATION_SNAP_VIEWED = 'snap_viewed'
NOTIFICATION_SNAP_REPLAYED  = 'snap_replayed'
NOTIFICATION_SNAP_SCREENSHOT_MADE = 'snap_screenshot_made'

NOTIFICATION_MESSAGE_RECEIVED = 'message_received'
NOTIFICATION_MESSAGE_READ = 'message_read'

STREAM_MESSAGE_SENT = 'message_sent'
STREAM_MESSAGE_TYPING = 'message_typing'
STREAM_MESSAGE_READED = 'message_readed'

def stream_message_sent(id)
  STREAM_MESSAGE_SENT + "\##{id}"
end

def stream_message_typing(id)
  STREAM_MESSAGE_TYPING + "\##{id}"
end

def stream_message_readed(id)
  STREAM_MESSAGE_READED + "\##{id}"
end

MESSAGE_AUTHOR_ID = 'author_id'
MESSAGE_RECIPIENT_ID = 'recipient_id'
MESSAGE_CONTENT = 'message'
