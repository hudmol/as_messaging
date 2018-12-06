class Message < Sequel::Model(:message)

  include ASModel
  include Relationships

  corresponds_to JSONModel(:message)
  set_model_scope :repository

  # We can be assigned to users
  define_relationship(:name => :message_assignee_user,
                      :json_property => 'assignee_user',
                      :contains_references_to_types => proc {[User]},
                      :is_array => false)

  ArchivesSpaceService.loaded_hook do
    User.define_relationship(:name => :message_assignee_user,
                             :contains_references_to_types => proc {[Message]},
                             :is_array => false)
  end


  # FIXME: We should be assignable to groups too (via a different relationship
  # and field)

  def assign_to_user(username)
    user = User.filter(:username => username).first or
      raise InvalidUsernameException.new

    assignee_user_relationship = assignee_relationship(:message_assignee_user)

    # Remove any existing assignee and grab their URI
    old_assignee_user = if assignee_user_relationship
                          uri = assignee_user_relationship.uri_for_other_referent_than(self)
                          assignee_user_relationship.delete

                          uri
                        end

    if user.uri != old_assignee_user
      puts "Hey!  A new assignee!  We should log this as history somewhere."
    end

    now = Time.now
    self.class.find_relationship(:message_assignee_user)
      .relate(self, user,
              {
                :aspace_relationship_position => 1,
                :system_mtime => now,
                :user_mtime => now
              })
  end


  def update_from_json(json, opts = {})
    assignee_user_relationship = assignee_relationship(:message_assignee_user)

    old_assignee_user = assignee_user_relationship ? assignee_user_relationship.uri_for_other_referent_than(self) : nil
    new_assignee_user = (json['assignee_user'] || {})['ref']

    if old_assignee_user != new_assignee_user
      puts "Hey!  A new assignee!  We should log this as history somewhere."
    end

    super
  end

  def self.create_from_json(json, opts = {})
    if json['assignee_user']
      puts "Hey!  A new assignee!  We should log this as history somewhere."
    end

    super
  end

  private

  def assignee_relationship(relationship_name)
    self.class.find_relationship(relationship_name).find_by_participant(self)[0]
  end

end
