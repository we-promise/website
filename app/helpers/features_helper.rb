module FeaturesHelper
  def assistant_features
    [
      {
        icon: "messages-square",
        title: "Natural language chat",
        description: "Ask questions in plain language and get answers drawn from your accounts, transactions, budgets and holdings."
      },
      {
        icon: "chart-column-increasing",
        title: "Context-aware",
        description: "Answers use your own categories, merchants and history rather than generic advice."
      },
      {
        icon: "cpu",
        title: "Your model, your choice",
        description: "Use a hosted model like OpenAI or Anthropic, or run one locally so your data never leaves your server."
      },
      {
        icon: "eye-off",
        title: "Private by default",
        description: "AI stays off until you turn it on, and you decide which model sees your data."
      },
      {
        icon: "link-2",
        title: "Works across all account types",
        description: "Sure AI can access insights from everything you link."
      },
      {
        icon: "wand-sparkles",
        title: "It can act, too",
        description: "Ask it to create a rule, fix a category or move money between budget categories."
      }
    ]
  end
end
