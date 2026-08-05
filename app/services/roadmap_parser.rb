class RoadmapParser
  HEADER = "<!-- roadmap:v1 -->"
  PHASE_PATTERN = /^## Phase:\s*(.+?)\s*$/
  ITEM_PATTERN = /^### Item:\s*(.+?)\s*$/

  class ParseError < StandardError; end

  def initialize(path)
    @path = Pathname.new(path)
  end

  def parse
    lines = @path.read.lines.map(&:chomp)
    raise ParseError, "Roadmap must begin with #{HEADER}" unless lines.shift&.strip == HEADER

    phases = []
    current_phase = nil
    current_item = nil

    lines.each do |line|
      stripped = line.strip
      next if stripped.empty?

      if (match = stripped.match(PHASE_PATTERN))
        phases << finish_phase(current_phase) if current_phase
        current_phase = { title: match[1], description: nil, items: [] }
        current_item = nil
      elsif (match = stripped.match(ITEM_PATTERN))
        raise ParseError, "Item appears before a phase" unless current_phase

        current_phase[:items] << finish_item(current_item) if current_item
        current_item = { title: match[1], status: nil, description: nil }
      elsif stripped.start_with?("Description:")
        description = stripped.delete_prefix("Description:").strip
        raise ParseError, "Description appears before a phase or item" unless current_phase

        if current_item
          current_item[:description] = description
        else
          current_phase[:description] = description
        end
      elsif stripped.start_with?("Status:")
        raise ParseError, "Status appears before an item" unless current_item

        current_item[:status] = stripped.delete_prefix("Status:").strip
      elsif current_item && current_item[:description].nil?
        current_item[:description] = stripped
      else
        raise ParseError, "Unexpected roadmap content: #{stripped}"
      end
    end

    if current_phase
      current_phase[:items] << finish_item(current_item) if current_item
      phases << finish_phase(current_phase)
    end
    raise ParseError, "Roadmap does not contain any phases" if phases.empty?

    phases
  end

  private

  def finish_phase(phase)
    raise ParseError, "Phase is missing a description" if phase[:description].blank?
    raise ParseError, "Phase #{phase[:title]} does not contain any items" if phase[:items].empty?

    phase.merge(items: phase[:items].dup)
  end

  def finish_item(item)
    raise ParseError, "Item #{item[:title]} is missing a status" if item[:status].blank?

    item
  end
end
