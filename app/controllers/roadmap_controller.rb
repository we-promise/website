class RoadmapController < ApplicationController
  def show
    @phases = RoadmapParser.new(Rails.root.join("docs/roadmap.md")).parse
    @items = @phases.flat_map { |phase| phase[:items] }
    @status_counts = @items.group_by { |item| item[:status] }.transform_values(&:count)
  end
end
