module Alex
  Tool = Struct.new(:name, :description, :requires_approval, :callable, :input_schema, keyword_init: true) do
    def call(arguments = {})
      callable.call(arguments)
    end

    def provider_schema
      { "name" => name, "description" => description, "input_schema" => input_schema || { "type" => "object", "properties" => {} } }
    end
  end
end
