from robot.api.deco import keyword

from Browser import Browser
from Browser.base.librarycomponent import LibraryComponent
from Browser.utils import SettingsStack, Scope


URL_BANNER_FUNCTION = """(show) => {
    let content = '';
    if (show) {
        const url = window.location.href;
        content = `body::before {
            content: '${url}';
            position: fixed;
            z-index: 9999;
            border: 1px solid lightblue;
            border-radius: 1rem;
            background: #00008b90;
            color: white;
            padding: 2px 10px;
            pointer-events: none;
            font-family: monospace;
            font-size: medium;
            font-weight: normal;
            white-space: pre;
            top: 5px;
            right: 5px;
        }`;
    }

    const urlBanner = document.getElementById('urlBanner');
    if (urlBanner) {
        urlBanner.textContent = content;
    } else {
        const urlBanner = document.createElement("style");
        urlBanner.setAttribute("id", 'urlBanner');
        urlBanner.textContent = content;
        document.head.appendChild(urlBanner);
    }
}"""


class LocationBanner(LibraryComponent):
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, library: Browser, show_banner: bool = False):
        super().__init__(library)
        library.scope_stack["location_banner"] = SettingsStack(show_banner, library)
        self.banner = show_banner

    def end_keyword(self, _kw, _args):
        try:
            banner = self.library.scope_stack["location_banner"].get()
            if banner or self.banner:
                self.library.evaluate_javascript(None, URL_BANNER_FUNCTION, arg=banner)
            self.banner = banner
        except Exception:
            pass

    @keyword
    def set_location_banner(self, active: bool, scope: Scope = Scope.Test):
        self.library.scope_stack["location_banner"].set(active, scope)