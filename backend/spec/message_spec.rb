require 'spec_helper'
require 'factory_bot'

describe 'Message' do

  let(:test_title) { 'Need expense report by COB' }
  let(:test_summary) { ('badger ' * 4096).strip }

  let!(:test_user_1) { create(:user, :username => 'guybrush') }
  let!(:test_user_2) { create(:user, :username => 'elaine') }

  it "creates a message with only a title" do
    msg = Message.create_from_json(JSONModel(:message)
                                     .from_hash(:title => test_title))

    json = Message.to_jsonmodel(msg.id)

    expect(json.title).to eq(test_title)
  end

  it "supports a pretty long summary too" do
    msg = Message.create_from_json(JSONModel(:message)
                                     .from_hash(:title => test_title,
                                                :summary => test_summary))

    json = Message.to_jsonmodel(msg.id)

    expect(json.summary).to eq(test_summary)
  end

  it "can be assigned between users" do

    # You can create a message with an initial assignment

    msg = Message.create_from_json(JSONModel(:message)
                                     .from_hash(:title => test_title,
                                                :assignee_user => {:ref => test_user_1.uri}))

    expect(Message.to_jsonmodel(msg.id).assignee_user['ref']).to eq(test_user_1.uri)


    # Direct assign method without requiring a full record save.  Is this useful
    # for the sake of quick reassignments via AJAX perhaps?

    Message.this_repo[msg.id].assign_to_user(test_user_2.username)

    expect(Message.to_jsonmodel(msg.id).assignee_user['ref']).to eq(test_user_2.uri)


    # But you can just fetch and update the full message record and reassign
    # that way... whatever makes you happy.

    json = Message.to_jsonmodel(msg.id)
    json.assignee_user = {'ref' => test_user_1.uri}
    Message.this_repo[msg.id].update_from_json(json)

    expect(Message.to_jsonmodel(msg.id).assignee_user['ref']).to eq(test_user_1.uri)
  end

  it "unassigns messages when the assigned user is deleted" do
    redcoat = create(:user, :username => 'doomed')

    msg = Message.create_from_json(JSONModel(:message)
                                     .from_hash(:title => test_title,
                                                :assignee_user => {:ref => redcoat.uri}))

    redcoat.delete

    expect(Message.to_jsonmodel(msg.id).assignee_user).to be_nil
  end

  it "can provide a list of messages assigned to a given user" do
    [test_user_1, test_user_1, test_user_2].each do |user|
      Message.create_from_json(JSONModel(:message)
                                 .from_hash(:title => test_title,
                                            :assignee_user => {:ref => user.uri}))
    end

    expect(Message.messages_for_user(test_user_1.username).length).to eq(2)
    expect(Message.messages_for_user(test_user_2.username).length).to eq(1)
  end

end
