module Bunnicula
  module DslBase
    def dsl_attr(*args)
      options = args.extract_options!
      [args].flatten.each {|attr|create_property_for(attr,options)}
    end

    private

    def create_property_for(attr,options)
      class_eval <<-end_eval
      @@dsl_attr_defaults ||= {}
      @@dsl_attr_defaults['#{attr}'] = #{options[:default].inspect}

      def #{attr}(val = nil)
        return @#{attr} || @@dsl_attr_defaults['#{attr}'] unless val
        @#{attr} = val
      end
      end_eval
      if (alias_list = options[:alias])
        [alias_list].flatten.each {|attr_alias| alias_method(attr_alias, attr.to_sym)}
      end
    end
  end
end