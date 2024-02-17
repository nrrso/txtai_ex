defmodule ExampleEmbeddings do
  alias TxtaiEx.Embeddings

  @data [
    "US tops 5 million confirmed virus cases",
    "Canada's last fully intact ice shelf has suddenly collapsed, forming a Manhattan-sized iceberg",
    "Beijing mobilises invasion craft along coast as Taiwan tensions escalate",
    "The National Park Service warns against sacrificing slower friends in a bear attack",
    "Maine man wins $1M from $25 lottery ticket",
    "Make huge profits without work, earn up to $100,000 a day"
  ]

  @queries [
    "feel good story",
    "climate change",
    "public health story",
    "war",
    "wildlife",
    "asia",
    "lucky",
    "dishonest junk"
  ]

  def run do
    # Assuming API.new/2 is defined and returns a struct with URL and optional token
    embeddings = Embeddings.new("http://localhost:8000", nil)

    IO.puts("Running similarity queries")
    IO.puts(String.pad_trailing("Query", 20) <> "Best Match")
    IO.puts(String.duplicate("-", 50))

    Enum.each(@queries, fn query ->
      {:ok, results} = Embeddings.similarity(embeddings, query, @data)
      uid = hd(results)["id"]
      IO.puts(String.pad_trailing(query, 20) <> Enum.at(@data, uid))
    end)

    documents = Enum.with_index(@data, 0) |> Enum.map(fn {text, index} -> %{id: index, text: text} end)

    Embeddings.add(embeddings, documents)
    Embeddings.index(embeddings)

    IO.puts("\nBuilding an Embeddings index")
    IO.puts(String.pad_trailing("Query", 20) <> "Best Match")
    IO.puts(String.duplicate("-", 50))

    Enum.each(@queries, fn query ->
      {:ok, results} = Embeddings.search(embeddings, query, 1)
      uid = hd(results)["id"]
      IO.puts(String.pad_trailing(query, 20) <> Enum.at(@data, uid))
    end)

    updated_data = List.replace_at(@data, 0, "See it: baby panda born")

    Embeddings.delete(embeddings, [5])
    Embeddings.add(embeddings, [%{id: 0, text: hd(updated_data)}])
    Embeddings.upsert(embeddings)

    IO.puts("\nTest delete/upsert/count")
    IO.puts(String.pad_trailing("Query", 20) <> "Best Match")
    IO.puts(String.duplicate("-", 50))

    {:ok, results} = Embeddings.search(embeddings, "feel good story", 1)
    uid = hd(results)["id"]
    IO.puts(String.pad_trailing("feel good story", 20) <> Enum.at(updated_data, uid))

    {:ok, count} = Embeddings.count(embeddings)
    IO.puts("\nTotal Count: #{Integer.to_string(count)}")
  end
end

Example.run()
