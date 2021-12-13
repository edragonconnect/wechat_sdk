defmodule WeChat.SDK.Publish do
  @moduledoc "发布能力"
  import Jason.Helpers
  alias WeChat.{SDK, SDK.DraftBox}

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Publish"

  @typedoc "发布任务的id"
  @type publish_id :: String.t()
  @typedoc "成功发布时返回的 article_id"
  @type article_id :: String.t()

  @doc """
  发布接口 -
  [官方文档](#{@doc_link}/Publish.html){:target="_blank"}

  开发者需要先将图文素材以草稿的形式保存（见“草稿箱/新建草稿”，如需从已保存的草稿中选择，见“草稿箱/获取草稿列表”），选择要发布的草稿 media_id 进行发布
  """
  @spec publish(SDK.client(), DraftBox.media_id()) :: SDK.response()
  def publish(client, media_id) do
    client.request(:post, url: "/cgi-bin/freepublish/submit", body: json_map(media_id: media_id))
  end

  @doc """
  发布状态轮询接口 -
  [官方文档](#{@doc_link}/Get_status.html){:target="_blank"}

  开发者可以尝试通过下面的发布状态轮询接口获知发布情况。
  """
  @spec get_status(SDK.client(), publish_id) :: SDK.response()
  def get_status(client, publish_id) do
    client.request(:post, url: "/cgi-bin/freepublish/get", body: json_map(publish_id: publish_id))
  end

  @doc """
  删除发布 -
  [官方文档](#{@doc_link}/Delete_posts.html){:target="_blank"}

  开发者可以尝试通过下面的发布状态轮询接口获知发布情况。

  ## 参数说明
    * index: 要删除的文章在图文消息中的位置，第一篇编号为1，该字段不填或填0会删除全部文章
  """
  @spec delete(SDK.client(), article_id, index :: integer) :: SDK.response()
  def delete(client, article_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/freepublish/delete",
      body: json_map(article_id: article_id, index: index)
    )
  end

  @doc """
  通过 article_id 获取已发布文章 -
  [官方文档](#{@doc_link}/Get_article_from_id.html){:target="_blank"}

  开发者可以通过 article_id 获取已发布的图文信息。
  """
  @spec get_article(SDK.client(), article_id) :: SDK.response()
  def get_article(client, article_id) do
    client.request(:post,
      url: "/cgi-bin/freepublish/getarticle",
      body: json_map(article_id: article_id)
    )
  end

  @doc """
  获取成功发布列表 -
  [官方文档](#{@doc_link}/Get_publication_records.html){:target="_blank"}

  开发者可以获取已成功发布的消息列表。

  ## 参数说明
    * offset: 从全部素材的该偏移位置开始返回，0表示从第一个素材 返回
    * count:  返回素材的数量，取值在1到20之间
    * no_content: 是否返回 content 字段
  """
  @spec batch_get(SDK.client(), count :: integer, offset :: integer, no_content :: boolean) ::
          SDK.response()
  def batch_get(client, count \\ 10, offset \\ 0, no_content \\ false) when count in 1..20 do
    client.request(:post,
      url: "/cgi-bin/freepublish/batchget",
      body: json_map(offset: offset, count: count, no_content: if(no_content, do: 1, else: 0))
    )
  end

  @doc """
  获取成功发布列表(stream) -
  [官方文档](#{@doc_link}/Get_publication_records.html){:target="_blank"}

  开发者可以获取已成功发布的消息列表。

  ## 参数说明
    * count:  返回素材的数量，取值在1到20之间
    * no_content: 是否返回 content 字段
  """
  @spec stream_get(SDK.client(), count :: integer, no_content :: boolean) :: Enumerable.t()
  def stream_get(client, count \\ 20, no_content \\ false) do
    Stream.unfold(0, fn offset ->
      with {:ok, %{status: 200, body: body}} <- batch_get(client, count, offset, no_content),
           %{"item" => items} when items != [] <- body do
        {items, offset + count}
      else
        _ -> nil
      end
    end)
    |> Stream.flat_map(& &1)
  end
end
