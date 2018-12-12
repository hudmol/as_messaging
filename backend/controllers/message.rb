class ArchivesSpaceService < Sinatra::Base

  Endpoint.get('/repositories/:repo_id/messages/current-user-summary')
    .description("Summarise the messages for the current user")
    .params(["repo_id", :repo_id],
            ["resolve", :resolve])
    .permissions([:view_repository])
    .returns([200, "[(:user_message_summary)]"]) \
  do
    json = JSONModel(:user_message_summary).from_hash(
      {
        'assigned_to_user' => Message
                                .messages_for_user(current_user, params[:repo_id])
                                .map(&:uri),
        # TODO
        # 'created_by_user' => Message
        #                        .messages_created_by_user(current_user, params[:repo_id])
        #                        .map(&:uri),

      }
    )

    json_response(resolve_references(json, params[:resolve]))
  end

  Endpoint.post('/repositories/:repo_id/messages')
    .description("Create a Message")
    .params(["message", JSONModel(:message), "The record to create", :body => true],
            ["repo_id", :repo_id])
    .permissions([:view_repository])
    .returns([200, :created]) \
  do
    handle_create(Message, params[:message])
  end


end
