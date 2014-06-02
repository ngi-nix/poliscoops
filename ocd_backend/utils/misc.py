import json
import re
from lxml import etree


def load_sources_config(filename):
    """Loads a JSON file containing the configuration of the available
    sources.

    :param filename: the filename of the JSON file.
    :type filename: str.
    """
    if type(filename) == file:
        # Already an open file
        return json.load(filename)
    try:
        with open(filename) as json_file:
            return json.load(json_file)
    except IOError, e:
        e.strerror = 'Unable to load sources configuration file (%s)' % e.strerror
        raise


def load_object(path):
    """Load an object given it's absolute object path, and return it.

    The object can be a class, function, variable or instance.

    :param path: absolute object path (i.e. 'ocd_backend.extractor.BaseExtractor')
    :type path: str.
    """
    try:
        dot = path.rindex('.')
    except ValueError:
        raise ValueError, "Error loading object '%s': not a full path" % path

    module, name = path[:dot], path[dot+1:]
    try:
        mod = __import__(module, {}, {}, [''])
    except ImportError, e:
        raise ImportError, "Error loading object '%s': %s" % (path, e)

    try:
        obj = getattr(mod, name)
    except AttributeError:
        raise NameError, "Module '%s' doesn't define any object named '%s'" % (module, name)

    return obj


def parse_oai_response(content):
    """Parses an OAI XML response and returns an XML tree.

    The input source is expected to be in UTF-8. To get around
    well-formedness errors (which occur in many responses), bad characters
    are ignored.

    :param content: the OAI XML response as a string.
    :type content: string
    :rtype: lxml.etree._Element
    """
    content = unicode(content, 'UTF-8', 'replace')
    # get rid of character code 12 (form feed)
    content = content.replace(chr(12), '?')

    parser = etree.XMLParser(recover=True, encoding='utf-8')

    return etree.fromstring(content.encode('utf-8'), parser=parser)

def try_convert(conv, value):
    try:
        return conv(value)
    except ValueError:
        return value

def parse_date(regexen, date_str):
    """
        Parse a messy string into a granular date

        `regexen` is of the form [ (regex, (granularity, groups -> datetime)) ]
    """
    if date_str:
        for reg, (gran, dater) in regexen:
            m = re.match(reg, date_str)
            if m:
                try:
                    return gran, dater(m.groups())
                except ValueError:
                    return 0, None
    return 0, None

def parse_date_span(regexen, date1_str, date2_str):
    """
        Parse a start & end date into a (less) granular date

        `regexen` is of the form [ (regex, (granularity, groups -> datetime)) ]
    """
    date1_gran, date1 = parse_date(regexen, date1_str)
    date2_gran, date2 = parse_date(regexen, date2_str)

    if date2:
        # TODO: integrate both granularities
        if (date1_gran, date1) == (date2_gran, date2):
            return date1_gran, date1
        if (date2 - date1).days < 5*365:
            return 4, date1
        if (date2 - date1).days < 50*365:
            return 3, date1
        if (date2 - date1).days >= 50*365:
            return 2, date1
    else:
        return date1_gran, date1

