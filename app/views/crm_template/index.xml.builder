xml.instruct!                   # <?xml version="1.0" encoding="UTF-8"?>
# </html>
xml.html do                      # <html>
  #   </head>
  xml.head do                    #   <head>
    xml.title("History")        #     <title>History</title>
  end
  #   </body>
  xml.body do                    #   <body>
    xml.comment! "HI"           #     <! -- HI -->
    xml.h1("Header")            #     <h1>Header</h1>
    xml.p("paragraph")          #     <p>paragraph</p>
  end
end
