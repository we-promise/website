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
        answer: "We take your data privacy and security seriously. Please refer to our <a href='https://sure.am/privacy' class='font-medium text-gray-900'>Privacy Policy</a> for more information."
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

  def faq_questions_free
    [
      {
        question: "How will my payment be processed?",
        answer: "Our demo environment only collects contributions, processed via <a href='https://stripe.com' class='font-medium text-gray-900'>Stripe</a>. You should ask the PikaPods and Railway teams about their own pricing and payment processing."
      },
      {
        question: "Can I cancel my subscription at any time?",
        answer: "We sure hope so!  Again, ask the hosting team taking care of your installation. Recurring contributions on our demo environment can be cancelled at any time."
      },
      {
        question: "Is  Sure open source?",
        answer: "Yes, Sure is open source under the <a href='https://github.com/we-promise/sure/blob/main/LICENSE' class='font-medium text-gray-900'>AGPLv3 license</a>. You can find the source code on <a href='https://github.com/we-promise/sure' class='font-medium text-gray-900'>GitHub</a> and contribute to the project. No goods or services are provided in exchange for contributions. The software is fully usable without contributing."
      },
      {
        question: "Can I self-host Sure?",
        answer: "Absolutely!  You can self-host Sure and that continues to be our priority. Please refer to the <a href='https://github.com/we-promise/sure/tree/main/docs/hosting' class='font-medium text-gray-900'>GitHub repository</a> for more information."
      }
    ]
  end
end
