
function dummy_old_link(contents, book)
{
  var link = contents+".html"
  if(book != null)
    link = link + "#" + book
  return link
}

function dummyLoadCont(name, contents, book)
{
  location.href = dummy_old_link(contents, book)
}

function dummy_wb_topic(link)
{
  location.href = link
}

if (!parent.manLoadCont)
{
  parent.manLoadCont = dummyLoadCont
}

if (!parent.wb_topic)
{
  parent.wb_topic = dummy_wb_topic
}

