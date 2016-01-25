require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::Transform

  require 'csv'
  require 'time'
  CSV::Converters[:datePt2Date] = lambda{|s|
    begin
      Time.parse(s).to_date
    rescue ArgumentError
      s
    end
  }

  @raw = __dir__ + '/../../data/data.csv'
  @transformed = __dir__ + '/../../data/transformed.csv'

  def self.status
    new_status_csv  = []
    line = 2
    CSV.foreach(@raw, headers: true) do |c| # Iterate over each row of our CSV file
      if line == 2
        #Add headers
        new_status_csv << c.to_hash.keys - (['Status Ativo'] + ['Status Inativo'] + ['Status Parcial'] + ['Status Sem Informação']) + ['Status']
        c['Status'] = 'list'
      end
      c['Status'] = 'Community' if line == 3
      c['Status'] = nil if line == 4
      if line == 5
c['Status'] ="---
- Ativo
- Inativo
- Parcial
- Sem Informação
- Inválido
"
     end
     c['Status'] = 1 if line == 6
     c['Status'] = 0 if line == 7
     c['Status'] = 1 if line == 8
      if line >= 9
        sum=(c['Status Ativo']).to_i + (c['Status Inativo']).to_i + (c['Status Parcial']).to_i + (c['Status Sem Informação']).to_i
        c['Status'] = 'inválido'
        if sum != 1
          puts "Erro checando Status soma status #{sum} line #{line}"
        else
          c['Status'] = "Ativo" if (c['Status Ativo']).to_i == 1
          c['Status'] = "Inativo" if (c['Status Inativo']).to_i == 1
          c['Status'] = "Parcial" if (c['Status Parcial']).to_i == 1
          c['Status'] = "Sem Informação" if (c['Status Sem Informação']).to_i == 1
        end
      end
      c.delete('Status Ativo')
      c.delete('Status Inativo')
      c.delete('Status Parcial')
      c.delete('Status Sem Informação')
      new_status_csv << c
      line+=1
    end

    CSV.open(@transformed, 'w') do |csv| # Create a new file updated_guests.csv
      new_status_csv.each do |row|
        csv.puts row
      end
    end
  end
end
