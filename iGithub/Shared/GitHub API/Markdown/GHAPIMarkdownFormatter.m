//
//  GHAPIMarkdownFormatter.m
//  iGithub
//
//  Created by Oliver Letterer on 30.07.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GHAPIMarkdownFormatter.h"
#import "GithubAPI.h"
#import "GHMarkdownParser.h"

@implementation GHAPIMarkdownFormatter

+ (NSString *)fullHTMLPageFromMarkdownString:(NSString *)markdown {
    NSString *HTML = markdown.flavoredHTMLStringFromMarkdown;
    
    NSURL *styleURL = [[NSBundle bundleForClass:self] URLForResource:@"styles" withExtension:@"css"];
    NSString *cssHTML = [NSString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">\n", [styleURL absoluteString]];
    
    NSString *HTMLPage = [NSString stringWithFormat:@"<!DOCTYPE html>\n<html>\n<head>\n%@</head>\n<body>%@</body>\n</html>", cssHTML, HTML];
    return HTMLPage;
}

+ (NSString *)issueFormattedHTMLStringFromMarkdownString:(NSString *)markdown {
    NSString *fontSize = nil;
    NSString *color = nil;
    NSString *shadow = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fontSize = @"14px";
        color = @"rgb(127,127,127)";
        shadow = @";text-shadow:0px 0.5px #FFFFFF";
    } else {
        fontSize = @"13px";
        color = @"rgb(64,64,64)";
        shadow = @"";
    }
    
    NSMutableString *HTML = [markdown.flavoredHTMLStringFromMarkdown mutableCopy];
    
    [HTML replaceOccurrencesOfString:@"<p>" 
                          withString:[NSString stringWithFormat:@"<p style=\"color:%@;font-family:Helvetica;font-size:%@%@\">", color, fontSize, shadow] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<blockquote>" 
                          withString:[NSString stringWithFormat:@"<blockquote style=\"margin:1em 0;border-left:5px solid #ddd;padding-left:.6em;color:#555;\">"] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<pre><code>" 
                          withString:[NSString stringWithFormat:@"<pre style=\"padding:0;font-size:12px;\"><code style=\"font-size:12px;color:#444;padding:0 .2em;border:1px solid #dedede;\">"]
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<code>" 
                          withString:[NSString stringWithFormat:@"<code style=\"font-size:12px;color:#444;padding:0 .2em;border:1px solid #dedede;\">"]
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<div>" 
                          withString:[NSString stringWithFormat:@"<div style=\"color:%@;font-family:Helvetica;font-size:%@%@\">", color, fontSize, shadow] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<div>" 
                          withString:[NSString stringWithFormat:@"<div style=\"color:%@;font-family:Helvetica;font-size:%@%@\">" , color, fontSize, shadow]
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<ol>" 
                          withString:[NSString stringWithFormat:@"<ol style=\"color:%@;font-family:Helvetica;font-size:%@%@\">", color, fontSize, shadow] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<ul>" 
                          withString:[NSString stringWithFormat:@"<ul style=\"color:%@;font-family:Helvetica;font-size:%@%@\">", color, fontSize, shadow] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<li>" 
                          withString:[NSString stringWithFormat:@"<li style=\"color:%@;font-family:Helvetica;font-size:%@%@\">", color, fontSize, shadow] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    for (NSUInteger i = 1; i <= 6; i++) {
        [HTML replaceOccurrencesOfString:[NSString stringWithFormat:@"<h%u>", i] 
                              withString:[NSString stringWithFormat:@"<h%u style=\"color:%@;font-family:Helvetica%@\">", i, color, shadow] 
                                 options:NSLiteralSearch 
                                   range:NSMakeRange(0, HTML.length)];
    }
    
    return HTML;
}

+ (NSString *)selectedFormattedHTMLStringFromMarkdownString:(NSString *)markdown {
    NSString *fontSize = nil;
    NSString *color = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fontSize = @"14px";
        color = @"rgb(255,255,255)";
    } else {
        fontSize = @"13px";
        color = @"rgb(255,255,255)";
    }
    
    NSMutableString *HTML = [markdown.flavoredHTMLStringFromMarkdown mutableCopy];
    
    [HTML replaceOccurrencesOfString:@"<p>" 
                          withString:[NSString stringWithFormat:@"<p style=\"color:%@;font-family:Helvetica;font-size:%@\">", color, fontSize] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<blockquote>" 
                          withString:[NSString stringWithFormat:@"<blockquote style=\"margin:1em 0;border-left:5px solid #ddd;padding-left:.6em;color:#555;\">"] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<pre><code>" 
                          withString:[NSString stringWithFormat:@"<pre style=\"padding:0;font-size:12px;\"><code style=\"font-size:12px;color:#444;padding:0 .2em;border:1px solid #dedede;\">"]
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<code>" 
                          withString:[NSString stringWithFormat:@"<code style=\"font-size:12px;color:#444;padding:0 .2em;border:1px solid #dedede;\">"]
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<div>" 
                          withString:[NSString stringWithFormat:@"<div style=\"color:%@;font-family:Helvetica;font-size:%@\">", color, fontSize] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<div>" 
                          withString:@"<div style=\"color:%@;font-family:Helvetica;font-size:%@\">" 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<ol>" 
                          withString:[NSString stringWithFormat:@"<ol style=\"color:%@;font-family:Helvetica;font-size:%@\">", color, fontSize] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<ul>" 
                          withString:[NSString stringWithFormat:@"<ul style=\"color:%@;font-family:Helvetica;font-size:%@\">", color, fontSize] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    [HTML replaceOccurrencesOfString:@"<li>" 
                          withString:[NSString stringWithFormat:@"<li style=\"color:%@;font-family:Helvetica;font-size:%@\">", color, fontSize] 
                             options:NSLiteralSearch 
                               range:NSMakeRange(0, HTML.length)];
    
    for (NSUInteger i = 1; i <= 6; i++) {
        [HTML replaceOccurrencesOfString:[NSString stringWithFormat:@"<h%u>", i] 
                              withString:[NSString stringWithFormat:@"<h%u style=\"color:%@;font-family:Helvetica\">", i, color] 
                                 options:NSLiteralSearch 
                                   range:NSMakeRange(0, HTML.length)];
    }
    
    return HTML;
}

@end
