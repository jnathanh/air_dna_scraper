require 'csv'

class AirDnaCity

  delegate :keys, to: :csvable_data
  delegate :values, to: :csvable_data
  delegate :[], to: :csvable_data

  attr_accessor :data,:name
  def initialize(name, data)
    self.name = name
    self.data = data
  end

  def to_csv
    [
      (csvable_data.keys).to_csv,
      csvable_data.values.to_csv
    ]
  end

  def csvable_data
    return @csvable_data if @csvable_data.present?
    @csvable_data = {city: name}
    data.each do |k,v|
      if k[/^size_/]
        @csvable_data[k.to_s.concat('_count').to_sym] = v[:count]
        @csvable_data[k.to_s.concat('_share').to_sym] = v[:share]
      else
        @csvable_data[k] = v
      end
    end
    @csvable_data
  end
end