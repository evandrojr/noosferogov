require_relative '../rede_brasil_plugin'

class RedeBrasilPlugin::Transform

  require 'csv'
  require 'time'
  @raw = __dir__ + '/../../data/data.csv'
  @transformed = __dir__ + '/../../data/transformed.csv'

  def self.status
    new_status_csv  = []
    line = 2
    CSV.foreach(@raw, headers: true,
                :header_converters=> lambda do |f|
                  f.strip
                  f.gsub(/\n/,'')
                 end,
                :converters=> lambda {|f| f ? f.strip : nil}) do |row| # Iterate over each row of our CSV file
      better_csv_row = RedeBrasilPlugin::BetterCsvRow.new(row)
      if line == 2
        #Add headers
        new_status_csv << better_csv_row.to_hash.keys - (['Status Ativo'] + ['Status Inativo'] + ['Status Parcial'] + ['Status Sem Informação']) + ['Status']
        better_csv_row['Status'] = 'list'
      end
      better_csv_row['Status'] = 'Community' if line == 3
      better_csv_row['Status'] = nil if line == 4
      if line == 5
better_csv_row['Status'] ="---
- Ativo
- Inativo
- Parcial
- Sem Informação
- Inválido
"
     end
     better_csv_row['Status'] = 1 if line == 6
     better_csv_row['Status'] = 0 if line == 7
     better_csv_row['Status'] = 1 if line == 8
      if line >= 9
        sum=(better_csv_row['Status Ativo']).to_i + (better_csv_row['Status Inativo']).to_i + (better_csv_row['Status Parcial']).to_i + (better_csv_row['Status Sem Informação']).to_i
        better_csv_row['Status'] = 'inválido'
        if sum != 1
          puts "Erro checando Status soma status #{sum} line #{line}"
        else
          better_csv_row['Status'] = "Ativo" if (better_csv_row['Status Ativo']).to_i == 1
          better_csv_row['Status'] = "Inativo" if (better_csv_row['Status Inativo']).to_i == 1
          better_csv_row['Status'] = "Parcial" if (better_csv_row['Status Parcial']).to_i == 1
          better_csv_row['Status'] = "Sem Informação" if (better_csv_row['Status Sem Informação']).to_i == 1
        end
      end
      better_csv_row.delete('Status Ativo')
      better_csv_row.delete('Status Inativo')
      better_csv_row.delete('Status Parcial')
      better_csv_row.delete('Status Sem Informação')
      new_status_csv << better_csv_row.to_csvrow
      line+=1
    end

    CSV.open(@transformed, 'w') do |csv| # Create a new file updated_guests.csv
      new_status_csv.each do |row|
        csv.puts row
      end
    end
  end
end
