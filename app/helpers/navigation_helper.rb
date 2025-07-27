module NavigationHelper
  def header_nav_products
    [
      {
        title: "Tracking",
        description: "Link all your assets and debts",
        path: tracking_features_path,
        icon: "chart-line"
      },
      {
        title: "Transactions",
        description: "Edit and automate transactions effortlessly.",
        path: transactions_features_path,
        icon: "credit-card"
      },
      {
        title: "Budgeting",
        description: "Set limits, track budgets, and optimize finances.",
        path: budgeting_features_path,
        icon: "chart-pie"
      },
      {
        title: "Assistant",
        description: "Ask anything, get answers fast.",
        path: assistant_features_path,
        icon: "sparkles"
      }
    ]
  end

  def header_nav_resources_links
    [
      {
        text: "Join Community",
        path: "https://discord.gg/FTzQqpnwSh"
      },
      {
        text: "Self-Host",
        path: "https://github.com/we-promise/sure"
      },
      {
        text: "GitHub",
        path: "https://github.com/we-promise/sure"
      }
    ]
  end

  def footer_products
    [
      {
        text: "Tracking",
        path: tracking_features_path
      },
      {
        text: "Transactions",
        path: transactions_features_path
      },
      {
        text: "Budgeting",
        path: budgeting_features_path
      },
      {
        text: "Assistant",
        path: assistant_features_path
      }
    ]
  end

  def footer_resources
    [
      {
        text: "Join Community",
        path: "https://discord.gg/FTzQqpnwSh"
      },
      {
        text: "Contribute",
        path: "https://github.com/we-promise/sure"
      }
    ]
  end

  def footer_tools
    [
      {
        text: "Compound Interest Calculator",
        path: tool_path("compound-interest-calculator")
      },
      {
        text: "ROI Calculator",
        path: tool_path("roi-calculator")
      },
      {
        text: "Financial Freedom Calculator",
        path: tool_path("financial-freedom-calculator")
      },
      {
        text: "Exchange Rate Calculator",
        path: tool_path("exchange-rate-calculator")
      },
      {
        text: "All Tools",
        path: tools_path
      }
    ]
  end

  def footer_legal
    [
      {
        text: "Privacy Policy",
        path: privacy_path
      },
      {
        text: "Terms of Service",
        path: tos_path
      }
    ]
  end

  def footer_socials
    [
      {
        icon: image_tag("footer-discord.svg", alt: "Discord", class: "w-6 h-6"),
        path: "https://discord.gg/FTzQqpnwSh"
      },
      {
        icon: image_tag("badge-github.svg", alt: "GitHub", class: "w-6 h-6"),
        path: "https://github.com/we-promise/sure"
      }
    ]
  end
end
