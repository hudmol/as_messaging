{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "/repositories/:repo_id/messages/current-user-summary",
    "properties" => {
      "uri" => {"type" => "string"},

      "assigned_to_user" => {
        "type" => "array",
        "items" => {
          "type" => "object",
          "subtype" => "ref",
          "properties" => {
            "ref" => {"type" => {"type" => "JSONModel(:message) uri"}},
            "_resolved" => {
              "type" => "object",
              "readonly" => "true"
            }
          }
        }
      }
    }
  }
}
