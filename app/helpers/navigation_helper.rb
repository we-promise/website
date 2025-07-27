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
        text: "Personal Finance Articles",
        path: articles_path
      },
      {
        text: "Financial Terms",
        path: terms_path
      },
      {
        text: "Financial FAQs",
        path: faqs_path
      },
      {
        text: "About Us",
        path: about_path
      },
      {
        text: "Join Community",
        path: "https://link.sure.am/discord"
      },
      {
        text: "Self-Host",
        path: "https://github.com/we-promise/website"
      },
      {
        text: "GitHub",
        path: "https://github.com/we-promise/website"
      },
      {
        text: "Contact".html_safe + " " + lucide_icon("arrow-up-right", class: "text-gray-400 group-hover/contact:text-gray-900 transition-all duration-150 inline w-4 h-4").html_safe,
        path: "mailto:hello@sure.am"
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
      },
      {
        text: "Pricing",
        path: pricing_path
      }
    ]
  end

  def footer_resources
    [
      {
        text: "Personal Finance Articles",
        path: articles_path
      },
      {
        text: "Personal Finance Authors",
        path: authors_path
      },
      {
        text: "Personal Finance Tools",
        path: tools_path
      },
      {
        text: "Financial Terms",
        path: terms_path
      },
      {
        text: "Financial FAQs",
        path: faqs_path
      },
      {
        text: "Join Community",
        path: "https://link.sure.am/discord"
      },
      {
        text: "Self-Host",
        path: "https://github.com/we-promise/website"
      },
      {
        text: "Bank Support",
        path: bank_search_path
      },
      {
        text: "About Us",
        path: about_path
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
        icon: image_tag("footer-x.svg", alt: "X", class: "w-6 h-6"),
        path: "https://x.com/sure"
      },
      {
        icon: image_tag("footer-discord.svg", alt: "Discord", class: "w-6 h-6"),
        path: "https://link.sure.am/discord"
      },
      {
        icon: image_tag("footer-email.svg", alt: "Email", class: "w-6 h-6"),
        path: "mailto:hello@sure.am"
      },
      {
        icon: image_tag("footer-linkedin.svg", alt: "LinkedIn", class: "w-6 h-6"),
        path: "https://www.linkedin.com/company/sure"
      }
    ]
  end
end
