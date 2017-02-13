class ChatMessagesController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'ChatMessage', except: :create

  def thread
    @chat_messages = ChatMessage.unread_thread current_user, params[:participant]

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order])
    collection = search_collection(@chat_messages, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: ChatMessageSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end
end
