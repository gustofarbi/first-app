package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"io"
	"net/http"
	"text/template"
)

type user struct {
	Name string
	Pass string
}
type renderer struct {
	template *template.Template
}

func (r renderer) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return r.template.ExecuteTemplate(w, name, data)
}

func main() {
	e := echo.New()

	r := renderer{
		template: template.Must(template.ParseFiles("static/index.html")),
	}

	e.Renderer = r

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/", handler)

	e.Logger.Fatal(e.Start(":8000"))
}

func handler(c echo.Context) error {
	name := c.QueryParam("name")
	pass := c.QueryParam("pass")

	if err := c.Render(http.StatusOK, "index.html", user{
		Name: name,
		Pass: pass,
	}); err != nil {
		return err
	}

	return nil
}
