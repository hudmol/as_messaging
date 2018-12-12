class MessagesController < ApplicationController

  set_access_control  "view_repository" => [:index, :create]

  def index
    @user_summary = JSONModel(:user_message_summary).find(nil)
    @message = JSONModel(:message).new._always_valid!
  end

  def create
    # params
    require 'pp';$stderr.puts("\n*** DEBUG #{(Time.now.to_f * 1000).to_i} [messages_controller.rb:13 55ece]: " + {%Q^params^ => params}.pretty_inspect + "\n")

    handle_crud(:instance => :message,
                :model => JSONModel(:message),
                :on_invalid => ->(){ render action: "index" },
                :on_valid => ->(id){
                    flash[:success] = I18n.t("message._frontend.messages.created", JSONModelI18nWrapper.new(:message => @message))
                    redirect_to(:controller => :messages,
                                :action => :index) })
  end

  def current_record
    @message
  end

end
