require "great/version"
require "delegate"
require "sentimental"

module Great
  class Again
    @registrations = {}

    attr_reader :text
    def initialize(text)
      @text = text
    end

    def to_s
      [text, suffixes.sample].join(' ')
    end

    def suffixes
      self.class.processors.map{|processor|
        processor.new(text).suffixes
      }.flatten
    end

    def self.register(key, obj)
      @registrations[key] = obj
    end

    def self.processors
      @registrations.values
    end

    def self.for(text, analyzer: Sentimental.new, **args)
      analyzer.threshold = args.fetch(:threshold){ 0.1 }
      analyzer.load_defaults
      analyzer.load_senti_file(args.fetch(:sentiment_file){ __dir__ + '/great/sentiments.txt' })
      unless text.end_with?('.')
        text = text + '.'
      end
      @registrations.fetch(analyzer.sentiment(Punchline.new(text))){ self }.new(text)
    end

    # negativity is often saved for last
    class Punchline < DelegateClass(String)
      def to_s
        words = split
        if words.length > 15
          half = (words.length / 2).to_i
          words[-half, half].join(' ')
        else
          __getobj__
        end
      end
    end

    class Positive < Again
      Again.register(:positive, self)

      def suffixes
        [
          "Make America Great Again!",
          "The best."
        ].map(&[:upcase, :itself].sample)
      end
    end

    class Negative < Again
      Again.register(:negative, self)

      def suffixes
        [
          "Bad!",
          "Sad.",
          "Bozo",
          "What a mess."
        ].map(&[:upcase, :itself].sample)
      end
    end

    class Neutral < Again
      Again.register(:neutral, self)

      def suffixes
        [
          "Believe me.",
          "I'm tellin ya."
        ]
      end
    end
  end

  def Great(text, **args)
    Great::Again.for(text, **args).to_s
  end
end
