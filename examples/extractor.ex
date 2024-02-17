defmodule ExampleExtractor do
  alias TxtaiEx.Extractor

  @data [
    "Giants hit 3 HRs to down Dodgers",
    "Giants 5 Dodgers 4 final",
    "Dodgers drop Game 2 against the Giants, 5-4",
    "Blue Jays beat Red Sox final score 2-1",
    "Red Sox lost to the Blue Jays, 2-1",
    "Blue Jays at Red Sox is over. Score: 2-1",
    "Phillies win over the Braves, 5-0",
    "Phillies 5 Braves 0 final",
    "Final: Braves lose to the Phillies in the series opener, 5-0",
    "Lightning goaltender pulled, lose to Flyers 4-1",
    "Flyers 4 Lightning 1 final",
    "Flyers win 4-1"
  ]

  @questions ["What team won the game?", "What was score?"]
  @queries ["Red Sox - Blue Jays", "Phillies - Braves", "Dodgers - Giants", "Flyers - Lightning"]

  def run do
    extractor = Extractor.new("http://localhost:8000")

    Enum.each(@queries, fn query ->
      IO.puts("----#{query}----")

      queue = Enum.map(@questions, fn question ->
        %{name: question, query: query, question: question, snippet: false}
      end)

      {:ok, results} = Extractor.extract(extractor, queue, @data)
      IO.inspect(results)
    end)

    # Ad-hoc questions
    ad_hoc_question = "What hockey team won?"

    IO.puts("----#{ad_hoc_question}----")
    {:ok, results} = Extractor.extract(extractor, [%{name: ad_hoc_question, query: ad_hoc_question, question: ad_hoc_question, snippet: false}], @data)
    IO.inspect(results)
  rescue
    exception -> IO.puts(Exception.format(:error, exception, System.stacktrace()))
  end
end

ExampleExtractor.run()
