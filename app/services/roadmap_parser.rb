require "net/http"
require "uri"

class RoadmapParser
  DEFAULT_SOURCE_URL = "https://raw.githubusercontent.com/we-promise/sure/main/docs/roadmap.md"
  HEADER = "<!-- roadmap:v1 -->"
  PHASE_PATTERN = /^## Phase:\s*(.+?)\s*$/
  ITEM_PATTERN = /^### Item:\s*(.+?)\s*$/
  DEFAULT_OPEN_TIMEOUT = 2
  DEFAULT_READ_TIMEOUT = 2

  class ParseError < StandardError; end

  def initialize(source = nil, open_timeout: DEFAULT_OPEN_TIMEOUT, read_timeout: DEFAULT_READ_TIMEOUT)
    @source = source || ENV.fetch("SURE_ROADMAP_URL", DEFAULT_SOURCE_URL)
    @open_timeout = open_timeout
    @read_timeout = read_timeout
  end

  def parse
    lines = markdown.lines.map(&:chomp)
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

  def markdown
    return @source.read if @source.respond_to?(:read)
    return @source if @source.lstrip.start_with?(HEADER)

    if File.file?(@source)
      File.read(@source)
    elsif @source.match?(%r{\Ahttps?://})
      fetch_markdown
    else
      raise ParseError, "Roadmap source does not exist: #{@source}"
    end
  rescue Errno::ENOENT => e
    raise ParseError, "Unable to read roadmap source #{@source}: #{e.message}"
  end

  def fetch_markdown
    uri = URI.parse(@source)
    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: uri.scheme == "https",
      open_timeout: @open_timeout,
      read_timeout: @read_timeout
    ) { |http| http.get(uri.request_uri) }

    unless response.is_a?(Net::HTTPSuccess)
      raise ParseError, "Unable to fetch roadmap from #{@source}: HTTP #{response.code}"
    end

    response.body
  rescue ParseError
    raise
  rescue StandardError => e
    raise ParseError, "Unable to fetch roadmap from #{@source}: #{e.message}"
  end

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
