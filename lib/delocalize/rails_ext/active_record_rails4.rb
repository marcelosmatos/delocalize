ActiveRecord::ConnectionAdapters::Column.class_eval do
  def type_cast_with_localization(value)
    new_value = value
    if date?
      new_value = Date.parse_localized(value) rescue value
    elsif time?
      new_value = Time.parse_localized(value) rescue value
    elsif number?
      new_value = Numeric.parse_localized(value) rescue value
    end
    type_cast_without_localization(new_value)
  end

  alias_method_chain :type_cast, :localization
  
  def type_cast_for_write_with_localization(value)
    if number? && I18n.delocalization_enabled?
      old_value = value
      value = Numeric.parse_localized(value)
      # if type == :integer
      #   begin
      #     value = Integer(i) 
      #   rescue 
      #     value = old_value 
      #   end
      # else
      #   value = is_float?(value) ? value.to_f : old_value
      # end
      value
    end
    type_cast_for_write_without_localization(value)
  end

  alias_method_chain :type_cast_for_write, :localization
  
  # def is_float?(fl)
  #   !!Float(fl) rescue false
  # end
  

end
