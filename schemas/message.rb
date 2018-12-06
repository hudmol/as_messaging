{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "/repositories/:repo_id/messages",
    "properties" => {
      "uri" => {"type" => "string"},
      "title" => {"type" => "string", "minLength" => 1, "maxLength" => 16384, "ifmissing" => "error"},
      "summary" => {"type" => "string", "maxLength" => 65000},

      "assignee_user" => {
        "type" => "object",
        "subtype" => "ref",
        "properties" => {
          "ref" => {
            "type" => "JSONModel(:user) uri",
            "ifmissing" => "error"
          },
        }
      }
    }
  }
}

