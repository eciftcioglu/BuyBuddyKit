// BBKConnectionContext+RemoteAction.m
// Copyright (c) 2016-2018 BuyBuddy Elektronik Güvenlik Bilişim Reklam Telekomünikasyon Sanayi ve Ticaret Limited Şirketi ( https://www.buybuddy.co/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BBKConnectionContext+RemoteAction.h"

BBKConnectionContextHTTPMethod BBKHTTPMethodFromRemoteAction(BBKConnectionContextRemoteAction action)
{
    switch (action) {
        case BBKConnectionContextRemoteActionIndex:
        case BBKConnectionContextRemoteActionShow:
            return BBKConnectionContextHTTPMethodGET;
        case BBKConnectionContextRemoteActionCreate:
            return BBKConnectionContextHTTPMethodPOST;
        case BBKConnectionContextRemoteActionDelete:
            return BBKConnectionContextHTTPMethodDELETE;
        case BBKConnectionContextRemoteActionUpdate:
            return BBKConnectionContextHTTPMethodPUT;
    }
}

NSString *BBKNSStringFromHTTPMethod(BBKConnectionContextHTTPMethod method)
{
    switch (method) {
        case BBKConnectionContextHTTPMethodHEAD:
            return @"HEAD";
        case BBKConnectionContextHTTPMethodGET:
            return @"GET";
        case BBKConnectionContextHTTPMethodPOST:
            return @"POST";
        case BBKConnectionContextHTTPMethodPUT:
            return @"PUT";
        case BBKConnectionContextHTTPMethodPATCH:
            return @"PATCH";
        case BBKConnectionContextHTTPMethodDELETE:
            return @"DELETE";
        case BBKConnectionContextHTTPMethodOPTIONS:
            return @"OPTIONS";
    }
}

NSString *BBKNSStringFromRemoteAction(BBKConnectionContextRemoteAction action)
{
    switch (action) {
        case BBKConnectionContextRemoteActionIndex:
            return @"index";
        case BBKConnectionContextRemoteActionShow:
            return @"show";
        case BBKConnectionContextRemoteActionCreate:
            return @"create";
        case BBKConnectionContextRemoteActionDelete:
            return @"delete";
        case BBKConnectionContextRemoteActionUpdate:
            return @"update";
    }
}

NSString *BBKHTTPMethodNSStringFromRemoteAction(BBKConnectionContextRemoteAction action)
{
    BBKConnectionContextHTTPMethod method = BBKHTTPMethodFromRemoteAction(action);
    
    return BBKNSStringFromHTTPMethod(method);
}
