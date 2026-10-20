module PagesHelper
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
