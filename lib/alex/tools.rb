require "open3"

module Alex
  module Tools
    def self.registry(root: Dir.pwd)
      {
        "pwd" => Tool.new(name: "pwd", description: "Show the working directory", requires_approval: false,
                           callable: ->(_) { root }),
        "read_file" => Tool.new(name: "read_file", description: "Read a UTF-8 text file under the working directory", requires_approval: false,
                                 input_schema: { "type" => "object", "properties" => { "path" => { "type" => "string" } }, "required" => ["path"] },
                                 callable: ->(args) { read_file(root, args.fetch("path")) }),
        "shell" => Tool.new(name: "shell", description: "Run a shell command", requires_approval: true,
                            input_schema: { "type" => "object", "properties" => { "command" => { "type" => "string" } }, "required" => ["command"] },
                            callable: ->(args) { shell(root, args.fetch("command")) })
      }
    end

    def self.read_file(root, relative_path)
      path = File.expand_path(relative_path, root)
      raise "path escapes working directory" unless path == root || path.start_with?(root + File::SEPARATOR)
      raise "not a regular file" unless File.file?(path)
      File.read(path, 1_000_000)
    end

    def self.shell(root, command)
      stdout, stderr, status = Open3.capture3("/bin/sh", "-c", command, chdir: root)
      { "stdout" => stdout, "stderr" => stderr, "exit_status" => status.exitstatus }
    end
  end
end
