defmodule ExampleLabels do
  alias TxtaiEx.Labels

  @data [
    "Dodgers lose again, give up 3 HRs in a loss to the Giants",
    "Giants 5 Cardinals 4 final in extra innings",
    "Dodgers drop Game 2 against the Giants, 5-4",
    "Flyers 4 Lightning 1 final. 45 saves for the Lightning.",
    "Slashing, penalty, 2 minute power play coming up",
    "What a stick save!",
    "Leads the NFL in sacks with 9.5",
    "UCF 38 Temple 13",
    "With the 30 yard completion, down to the 10 yard line",
    "Drains the 3pt shot!!, 0:15 remaining in the game",
    "Intercepted! Drives down the court and shoots for the win",
    "Massive dunk!!! they are now up by 15 with 2 minutes to go"
  ]

  def run do
    labels = Labels.new("http://localhost:8000")

    # First set of tags
    tags = ["Baseball", "Football", "Hockey", "Basketball"]
    display_labels(labels, @data, tags)

    # Second set of tags
    tags = ["😀", "😡"]
    IO.puts()
    display_labels(labels, @data, tags)
  rescue
    exception -> IO.puts(Exception.format(:error, exception, System.stacktrace()))
  end

  defp display_labels(labels, data, tags) do
    IO.puts(String.pad_trailing("Text", 75) <> "Label")
    IO.puts(String.duplicate("-", 100))

    Enum.each(data, fn text ->
      {:ok, results} = Labels.label(labels, text, tags)
      label = Enum.at(tags, hd(results)["id"])

      IO.puts(String.pad_trailing(text, 75) <> label)
    end)
  end
end

ExampleLabels.run()
