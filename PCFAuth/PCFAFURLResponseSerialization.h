// PCFAFSerialization.h
//
// Copyright (c) 2013-2014 PCFAFNetworking (http://afnetworking.com)
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 The `PCFAFURLResponseSerialization` protocol is adopted by an object that decodes data into a more useful object representation, according to details in the server response. Response serializers may additionally perform validation on the incoming response and data.

 For example, a JSON response serializer may check for an acceptable status code (`2XX` range) and content type (`application/json`), decoding a valid JSON response into an object.
 */
@protocol PCFAFURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>

/**
 The response object decoded from the data associated with a specified response.

 @param response The response to be processed.
 @param data The response data to be decoded.
 @param error The error that occurred while attempting to decode the response data.

 @return The object decoded from the specified response data.
 */
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error;

@end

#pragma mark -

/**
 `PCFAFHTTPResponseSerializer` conforms to the `PCFAFURLRequestSerialization` & `PCFAFURLResponseSerialization` protocols, offering a concrete base implementation of query string / URL form-encoded parameter serialization and default request headers, as well as response status code and content type validation.

 Any request or response serializer dealing with HTTP is encouraged to subclass `PCFAFHTTPResponseSerializer` in order to ensure consistent default behavior.
 */
@interface PCFAFHTTPResponseSerializer : NSObject <PCFAFURLResponseSerialization>

/**
 The string encoding used to serialize parameters.
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 Creates and returns a serializer with default configuration.
 */
+ (instancetype)serializer;

///-----------------------------------------
/// @name Configuring Response Serialization
///-----------------------------------------

/**
 The acceptable HTTP status codes for responses. When non-`nil`, responses with status codes not contained by the set will result in an error during validation.

 See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 */
@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;

/**
 The acceptable MIME types for responses. When non-`nil`, responses with a `Content-Type` with MIME types that do not intersect with the set will result in an error during validation.
 */
@property (nonatomic, copy) NSSet *acceptableContentTypes;

/**
 Validates the specified response and data.

 In its base implementation, this method checks for an acceptable status code and content type. Subclasses may wish to add other domain-specific checks.

 @param response The response to be validated.
 @param data The data associated with the response.
 @param error The error that occurred while attempting to validate the response.

 @return `YES` if the response is valid, otherwise `NO`.
 */
- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *__autoreleasing *)error;

@end

#pragma mark -


/**
 `PCFAFJSONResponseSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that validates and decodes JSON responses.

 By default, `PCFAFJSONResponseSerializer` accepts the following MIME types, which includes the official standard, `application/json`, as well as other commonly-used types:

 - `application/json`
 - `text/json`
 - `text/javascript`
 */
@interface PCFAFJSONResponseSerializer : PCFAFHTTPResponseSerializer

/**
 Options for reading the response JSON data and creating the Foundation objects. For possible values, see the `NSJSONSerialization` documentation section "NSJSONReadingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Whether to remove keys with `NSNull` values from response JSON. Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

/**
 Creates and returns a JSON serializer with specified reading and writing options.

 @param readingOptions The specified JSON reading options.
 */
+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end

#pragma mark -

/**
 `PCFAFXMLParserSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that validates and decodes XML responses as an `NSXMLParser` objects.

 By default, `PCFAFXMLParserSerializer` accepts the following MIME types, which includes the official standard, `application/xml`, as well as other commonly-used types:

 - `application/xml`
 - `text/xml`
 */
@interface PCFAFXMLParserResponseSerializer : PCFAFHTTPResponseSerializer

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

/**
 `PCFAFXMLDocumentSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that validates and decodes XML responses as an `NSXMLDocument` objects.

 By default, `PCFAFXMLDocumentSerializer` accepts the following MIME types, which includes the official standard, `application/xml`, as well as other commonly-used types:

 - `application/xml`
 - `text/xml`
 */
@interface PCFAFXMLDocumentResponseSerializer : PCFAFHTTPResponseSerializer

/**
 Input and output options specifically intended for `NSXMLDocument` objects. For possible values, see the `NSJSONSerialization` documentation section "NSJSONReadingOptions". `0` by default.
 */
@property (nonatomic, assign) NSUInteger options;

/**
 Creates and returns an XML document serializer with the specified options.

 @param mask The XML document options.
 */
+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end

#endif

#pragma mark -

/**
 `PCFAFPropertyListSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that validates and decodes XML responses as an `NSXMLDocument` objects.

 By default, `PCFAFPropertyListSerializer` accepts the following MIME types:

 - `application/x-plist`
 */
@interface PCFAFPropertyListResponseSerializer : PCFAFHTTPResponseSerializer

/**
 The property list format. Possible values are described in "NSPropertyListFormat".
 */
@property (nonatomic, assign) NSPropertyListFormat format;

/**
 The property list reading options. Possible values are described in "NSPropertyListMutabilityOptions."
 */
@property (nonatomic, assign) NSPropertyListReadOptions readOptions;

/**
 Creates and returns a property list serializer with a specified format, read options, and write options.

 @param format The property list format.
 @param readOptions The property list reading options.
 */
+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions;

@end

#pragma mark -

/**
 `PCFAFImageSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that validates and decodes image responses.

 By default, `PCFAFImageSerializer` accepts the following MIME types, which correspond to the image formats supported by UIImage or NSImage:

 - `image/tiff`
 - `image/jpeg`
 - `image/gif`
 - `image/png`
 - `image/ico`
 - `image/x-icon`
 - `image/bmp`
 - `image/x-bmp`
 - `image/x-xbitmap`
 - `image/x-win-bitmap`
 */
@interface PCFAFImageResponseSerializer : PCFAFHTTPResponseSerializer

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
/**
 The scale factor used when interpreting the image data to construct `responseImage`. Specifying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the size property. This is set to the value of scale of the main screen by default, which automatically scales images for retina displays, for instance.
 */
@property (nonatomic, assign) CGFloat imageScale;

/**
 Whether to automatically inflate response image data for compressed formats (such as PNG or JPEG). Enabling this can significantly improve drawing performance on iOS when used with `setCompletionBlockWithSuccess:failure:`, as it allows a bitmap representation to be constructed in the background rather than on the main thread. `YES` by default.
 */
@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;
#endif

@end

#pragma mark -

/**
 `PCFAFCompoundSerializer` is a subclass of `PCFAFHTTPResponseSerializer` that delegates the response serialization to the first `PCFAFHTTPResponseSerializer` object that returns an object for `responseObjectForResponse:data:error:`, falling back on the default behavior of `PCFAFHTTPResponseSerializer`. This is useful for supporting multiple potential types and structures of server responses with a single serializer.
 */
@interface PCFAFCompoundResponseSerializer : PCFAFHTTPResponseSerializer

/**
 The component response serializers.
 */
@property (readonly, nonatomic, copy) NSArray *responseSerializers;

/**
 Creates and returns a compound serializer comprised of the specified response serializers.

 @warning Each response serializer specified must be a subclass of `PCFAFHTTPResponseSerializer`, and response to `-validateResponse:data:error:`.
 */
+ (instancetype)compoundSerializerWithResponseSerializers:(NSArray *)responseSerializers;

@end