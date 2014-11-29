
function wb_bar_mouseover(but_name)
{                     
  var _image = wb_bar_img[but_name];
  _image.src = wb_bar_img[but_name + "_over"].src;
                            
  var status_msg = wb_bar_msg(but_name, "status");
      
  if (but_name == "lang")
  {
    status_msg += " [";
    var langs = parent.wb_usr.langs;
    var first = 1;
    
  for (var i = 0; i < langs.length; i++) 
    {   
      if (!first)
        status_msg += ", ";
      else
        first = 0;
      
      if (langs[i] == parent.wb_cur_lang)
        status_msg += ">";
      
      status_msg += langs[i];
      
      if (langs[i] == parent.wb_cur_lang)
        status_msg += "<";
    }
    
    status_msg += "]";
  }
  
  status = status_msg;
  
  // Continue to process the mouseover event
  return true;
}

function wb_bar_mouseout(but_name)
{
  var _image = wb_bar_img[but_name];
  _image.src = wb_bar_img[but_name + "_normal"].src;

  status = ""; 
  
  // Continue to process the mouseout event
  return true;
}

function _wb_make_image(name)
{
  var _image = new Image();
  _image.src  = "wb_img/bar_" + name + ".gif";
  return _image;
}
                            
function _wb_get_layer(name)
{
  if (document.layers)
    return document.layers[name];
  else if (document.all)
    return document.all[name];
  else
    return document.getElementById(name);
}

function _wb_set_img(layer, name, img_normal, img_over)
{                                
  wb_bar_img[name + "_normal"] = img_normal;
  wb_bar_img[name + "_over"] = img_over;
  
  if (layer.document)
    wb_bar_img[name] = layer.document.images["wb_" + name];
  else
    wb_bar_img[name] = document.images["wb_" + name];

  if (wb_bar_img[name])    
    wb_bar_img[name].alt = wb_bar_msg(name, "alt");
}

function _wb_load_button(layer, name)
{                      
  var img_normal = _wb_make_image(name);
  var img_over = _wb_make_image(name + "_over");
  _wb_set_img(layer, name, img_normal, img_over);
}

function _wb_update_img_alt(name)
{                                
  wb_bar_img[name].alt = wb_bar_msg(name, "alt");
}
  
function _wb_update_lang(layer)
{                                
  var img_normal = wb_bar_img["lang_" + parent.wb_cur_lang + "_normal"];
  var img_over = wb_bar_img["lang_" + parent.wb_cur_lang + "_over"]
  _wb_set_img(layer, "lang", img_normal, img_over);
  
  _wb_update_img_alt("exp_all");
  _wb_update_img_alt("cont_all");
  _wb_update_img_alt("home");
  _wb_update_img_alt("sync");
  _wb_update_img_alt("previous");
  _wb_update_img_alt("next");
  _wb_update_img_alt("mail");
  _wb_update_img_alt("lang");
}

function wb_bar_mail()
{
  location.href = "mailto:" + parent.wb_usr.contact;
}

function wb_bar_msg(name, dest)
{
  return wb_bar_messages[parent.wb_cur_lang][name][dest];
}

function wb_bar_webbook()
{  
  window.open("http://www.tecgraf.puc-rio.br/webbook");
}

function wb_bar_init()
{
  // Load images in the cache
  wb_bar_img = { };
  
  var layer = _wb_get_layer("layer0");
                             
  _wb_load_button(layer, "exp_all");
  _wb_load_button(layer, "cont_all");
  _wb_load_button(layer, "home");
  _wb_load_button(layer, "sync");
  _wb_load_button(layer, "previous");
  _wb_load_button(layer, "next");
  _wb_load_button(layer, "mail");
  _wb_load_button(layer, "lang_en");
  _wb_load_button(layer, "lang_pt");
  
  _wb_update_lang(layer);
}
  
