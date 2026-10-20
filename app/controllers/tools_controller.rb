class ToolsController < ApplicationController
  def index
    @tools = Tool.all

    # Hide tools that require real market data APIs
    hidden_tools = %w[exchange-rate-calculator stock-portfolio-backtest bogleheads-growth-calculator]
    @tools = @tools.where.not(slug: hidden_tools)

    if params[:category].present?
      # Ensure category_slug is valid by checking against existing values
      valid_categories = Tool.distinct.pluck(:category_slug)
      @tools = @tools.where(category_slug: params[:category]) if valid_categories.include?(params[:category])
    end

    if params[:q].present?
      @query = params[:q].to_s.strip
      # Use sanitize_sql_like to escape special characters in the search query
      @tools = @tools.where("title ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%")
    end
  end

  def show
    # Check if the requested tool is in the hidden list
    hidden_tools = %w[exchange-rate-calculator stock-portfolio-backtest bogleheads-growth-calculator]
    if hidden_tools.include?(params[:slug])
      render_404
      return
    end

    presenter = Tool.presenter_class_for(params[:slug])
    @tool = presenter.new tool_params(presenter).compact_blank.merge(action_name: action_name)
    @more_tools = Tool.random_sample(4, exclude: @tool)
  end

  private
    # Only the attributes this tool's presenter declares, so a param meant
    # for another tool can't raise an unknown attribute error.
    def tool_params(presenter)
      params.except(:slug).permit(*presenter.attribute_names)
    end

    def render_404
      render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
    end
end
