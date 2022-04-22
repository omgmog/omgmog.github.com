---
comments_issue: 77
title: Maintaining updates for a bunch of WordPress sites with Google Spreadsheets
---

Here's a useful trick I've come up with, to maintain a list of WordPress installations and easily see if they're up to date.

<!-- more -->

### Getting the currently installed version

Create a sheet with your domain names

{: .center}
{% include posts/figure.html src="Screen%20Shot%202015-04-28%20at%2011.55.13.png" %}{:.massive.center}

In the second column, you'll want a formula that uses `ImportXML()` to grab the `/feed/` for each domain, and then use `REGEXEXTRACT()` to extract the version number:

```text
=REGEXEXTRACT(ImportXML(CONCATENATE($A2,"/feed/"), "//generator"),"\?v=(.*)$")
```

This will give us, for example `4.2.1` from the `<generator>` field in the `/feed/`.

### Checking against the latest release

Create a new empty sheet, then in cell `A1` paste the following:

```text
=IMPORTHTML("https://wordpress.org/download/release-archive/", "table", 1)
```

This will populate the sheet with the release data from the [WordPress wiki](https://wordpress.org/download/release-archive/). We only need the data in cell `A2`.

Go back to your first sheet and in a new column, you can add a test to see if the installed version is greater than or equal to the latest release. This will give you `TRUE` or `FALSE`.

```text
=GTE($C2, Sheet2!$A$2)
```

You can view a working version of this spreadsheet [on Google Drive](https://docs.google.com/spreadsheets/d/1axN2jaxXZGHkC5tJy3we4ssp1Qvzfs7C8XQ9MNEJZZQ/edit?usp=sharing)
