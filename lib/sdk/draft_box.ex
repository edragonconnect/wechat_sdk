defmodule WeChat.SDK.DraftBox do
  @moduledoc "草稿箱"
  import Jason.Helpers
  alias WeChat.{SDK, Material.Article}

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Draft_Box"

  @typedoc "草稿箱的media_id"
  @type media_id :: String.t()

  @doc """
  新建草稿 -
  [官方文档](#{@doc_link}/Add_draft.html){:target="_blank"}

  开发者可新增常用的素材到草稿箱中进行使用。上传到草稿箱中的素材被群发或发布后，该素材将从草稿箱中移除。新增草稿可在公众平台官网-草稿箱中查看和管理。
  """
  @spec add(SDK.client(), Article.t()) :: SDK.response()
  def add(client, article) do
    client.request(:post, url: "/cgi-bin/draft/add", body: json_map(articles: [article]))
  end

  @doc """
  获取草稿 -
  [官方文档](#{@doc_link}/Get_draft.html){:target="_blank"}

  新增草稿后，开发者可以根据草稿指定的字段来下载草稿。
  """
  @spec get(SDK.client(), media_id) :: SDK.response()
  def get(client, media_id) do
    client.request(:post, url: "/cgi-bin/draft/get", body: json_map(media_id: media_id))
  end

  @doc """
  删除草稿 -
  [官方文档](#{@doc_link}/Delete_draft.html){:target="_blank"}

  新增草稿后，开发者可以根据本接口来删除不再需要的草稿，节省空间。**此操作无法撤销，请谨慎操作。**
  """
  @spec delete(SDK.client(), media_id) :: SDK.response()
  def delete(client, media_id) do
    client.request(:post, url: "/cgi-bin/draft/delete", body: json_map(media_id: media_id))
  end

  @doc """
  修改草稿 -
  [官方文档](#{@doc_link}/Update_draft.html){:target="_blank"}

  开发者可通过本接口对草稿进行修改。
  """
  @spec update(SDK.client(), media_id, Article.t(), index :: integer) :: SDK.response()
  def update(client, media_id, article, index \\ 0) do
    client.request(:post,
      url: "/cgi-bin/draft/update",
      body: json_map(media_id: media_id, index: index, articles: article)
    )
  end

  @doc """
  获取草稿总数 -
  [官方文档](#{@doc_link}/Count_drafts.html){:target="_blank"}

  开发者可以根据本接口来获取草稿的总数。此接口只统计数量，不返回草稿的具体内容。
  """
  @spec count(SDK.client()) :: SDK.response()
  def count(client) do
    client.request(:get, url: "/cgi-bin/draft/count")
  end

  @doc """
  获取草稿列表 -
  [官方文档](#{@doc_link}/Get_draft_list.html){:target="_blank"}

  新增草稿之后，开发者可以获取草稿的列表。

  ## 参数说明
    * offset: 从全部素材的该偏移位置开始返回，0表示从第一个素材 返回
    * count:  返回素材的数量，取值在1到20之间
    * no_content: 是否返回 content 字段
  """
  @spec batch_get(SDK.client(), count :: integer, offset :: integer, no_content :: boolean) ::
          SDK.response()
  def batch_get(client, count \\ 10, offset \\ 0, no_content \\ false) when count in 1..20 do
    client.request(:post,
      url: "/cgi-bin/draft/batchget",
      body: json_map(offset: offset, count: count, no_content: if(no_content, do: 1, else: 0))
    )
  end

  @doc """
  获取草稿列表(stream) -
  [官方文档](#{@doc_link}/Get_draft_list.html){:target="_blank"}

  新增草稿之后，开发者可以获取草稿的列表。

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
