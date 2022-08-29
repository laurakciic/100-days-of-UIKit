//
//  Scripts.swift
//  Extension
//
//  Created by Laura on 29.08.2022..
//

import Foundation

let scripts = [
    (title: "Display an alert",
         body: """
               alert("Page title: " + document.title + "\\nPage url: " + document.URL);
               """
    ),
    (title: "Replace page content",
         body: """
               document.body.innerHTML = '';
               let p = document.createElement('p');
               p.textContent = 'Page content replaced!';
               document.body.appendChild(p);
               """
    ),
    (title: "Split URL",
         body: """
               alert("Protocol: " + window.location.protocol + "\\nHost: " + window.location.host + "\\nPathname: " + window.location.pathname);
               """
    )
]
