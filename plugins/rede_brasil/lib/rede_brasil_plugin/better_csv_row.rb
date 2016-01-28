require 'csv'

class RedeBrasilPlugin::BetterCsvRow

  @csv_row
  @hash_low_case_keys

  def to_s
    @csv_row.to_s
  end

  def original_key(key)
    if(@hash_low_case_keys[key.downcase].present?)
      @hash_low_case_keys[key.downcase][:original_key]
    else
      nil
    end
  end

  def delete(key)
    @csv_row.delete(original_key(key))
    @hash_low_case_keys.delete(key.downcase)
  end

  def initialize(csv_row)
    raise "Parameter must be a CSV::Row" unless csv_row.class == CSV::Row
    @csv_row = csv_row
    @hash_low_case_keys = @csv_row.to_hash
    @csv_row.each do  |k,v|
      next unless v.present?
      @csv_row[k] = v.strip
      @csv_row[k] = @csv_row[k].gsub(/\ {2,}/,' ')
      @csv_row[k] = ActionView::Base.full_sanitizer.sanitize(@csv_row[k])
    end

    @csv_row.to_hash.each do |k, v|
      downcased_k = k.downcase
      @hash_low_case_keys[downcased_k] = {value: v, original_key: k}
    end
  end

  def == (key_x, key_y)
    @hash_low_case_keys[key_x.downcase][:value] == @hash_low_case_keys[key_y.downcase][:value]
  end

  def []=(key, value)
    ok = original_key(key)
    if ok.present?
      @csv_row[ok]=value
    else
      @csv_row[key]=value
    end
    @hash_low_case_keys[key.downcase] = {value: value, original_key: key}
  end

  def [] (key)
    @hash_low_case_keys[key.downcase][:value]
  end

  def to_hash
    @csv_row.to_hash
  end

  def to_csvrow
    @csv_row
  end

end
