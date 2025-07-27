module PagesHelper
  def faq_questions
    [
      {
        question: "How is my payment being processed?",
        answer: "All payments are securely processed through Stripe. Sure is billed either monthly at $9 per month or annually at $90 per year. You'll receive an email confirmation once the payment goes through."
      },
      {
        question: "What is your refund policy?",
        answer: "If Sure doesn't work for you, we offer a full refund—no questions asked. Just reach out to us at <a href='mailto:hello@sure.am' class='font-medium text-gray-900'>hello@sure.am</a> and we'll take care of it."
      },
      {
        question: "Can I cancel my subscription at any time?",
        answer: "Yes, you can cancel whenever you like. Your Sure benefits will remain active until the end of your current billing period, and you won't be charged again after that."
      },
      {
        question: "What are your data privacy & security policies?",
        answer: "We take your data privacy and security seriously. Please refer to our <a href='https://maybefinance.com/privacy' class='font-medium text-gray-900'>Privacy Policy</a> for more information."
      },
      {
        question: "Is  Sure open source?",
        answer: "Yes, Sure is open source. You can find the source code on <a href='https://github.com/we-promise/sure' class='font-medium text-gray-900'>GitHub</a>."
      },
      {
        question: "Can I self-host Sure?",
        answer: "Yes, you can self-host Sure. Please refer to the <a href='https://github.com/we-promise/sure' class='font-medium text-gray-900'>GitHub repository</a> for more information."
      }
    ]
  end
end
