defmodule ExamplePipeline do
  alias TxtaiEx.{Segmentation, Textractor, Summary, Translation, Transcription, Workflow}

  def run do
    service = "http://localhost:8000"

    sentences = "This is a test. And another test."

    IO.puts("---- Segmented Text ----")
    {:ok, segments} = Segmentation.segment(service, sentences)
    IO.inspect(segments)

    {:ok, text} = Textractor.textract(service, "/tmp/txtai/article.pdf")
    IO.puts("\n---- Extracted Text ----")
    IO.puts(text)

    {:ok, summarytext} = Summary.summary(service, text)
    IO.puts("\n---- Summary Text ----")
    IO.puts(summarytext)

    {:ok, translation} = Translation.translate(service, summarytext, "es")
    IO.puts("\n---- Summary Text in Spanish ----")
    IO.puts(translation)

    {:ok, output} = Workflow.workflow(service, "sumspanish", ["file:///tmp/txtai/article.pdf"])
    IO.puts("\n---- Workflow [Extract Text->Summarize->Translate] ----")
    IO.inspect(output)

    {:ok, transcription} = Transcription.transcribe(service, "/tmp/txtai/Make_huge_profits.wav")
    IO.puts("\n---- Transcribed Text ----")
    IO.puts(transcription)
  rescue
    exception -> IO.puts(Exception.format(:error, exception, System.stacktrace()))
  end
end

ExamplePipeline.run()
