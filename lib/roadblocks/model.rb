module Roadblocks

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def roadblocks
      @roadblocks ||= {}
    end

    def roadblocks_for(name, &block)
      self.class_eval do
        include InstanceMethods
        before_validation :clear_roadblocks

        def clear_roadblocks
          self.roadblock_errors = {}
        end
      end

      roadblocks[name] = block

      self.roadblocks.keys.each do |method_id|
        method_name = method_id.to_s.gsub(/\?/, '')
        self.class_eval <<-CODE
          after_validation :roadblocks_for_#{method_name}

          def roadblocks_for_#{method_name}
            @roadblock_scope ||= :#{method_name}
            self.#{method_name} = validate_roadblocks(:#{method_name})
          end
        CODE
      end
    end # roadblocks_for
  end # ClassMethods

  module InstanceMethods
    def returning(value)
      yield(value)
      value
    end

    def force_roadblocks_update!
      clear_roadblocks
      self.class.roadblocks.keys.each do |method_id|
        method_name = method_id.to_s.gsub(/\?/, '').to_sym
        update_column(method_name, send("validate_roadblocks", method_name))
      end
    end

    def roadblock_rule(message, &block)
      begin
        returning yield do |value|
          unless value
            self.roadblock_errors[@roadblock_scope] ||= []
            self.roadblock_errors[@roadblock_scope] << message
          end
        end
      rescue Exception => e
        self.roadblock_errors[@roadblock_scope] ||= []
        self.roadblock_errors[@roadblock_scope] << message
      end
    end

    def validate_roadblocks(roadblock_type)
      block = self.class.roadblocks[roadblock_type]
      self.roadblock_errors[roadblock_type] = []
      self.instance_eval(&block)
      self.roadblock_errors.delete(roadblock_type) if self.roadblock_errors[roadblock_type].empty?
      !roadblock_errors.keys.include?(roadblock_type)
    end
  end # InstanceMethods
end # Roadblocks
