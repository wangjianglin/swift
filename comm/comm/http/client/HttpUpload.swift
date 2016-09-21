//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPUpload.swift
//
//  Created by Dalton Cherry on 6/5/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

#if os(iOS)
    import MobileCoreServices
#endif


/// Object representation of a HTTP File Upload.
open class HttpUpload: NSObject {
    
    
    open func jsonSkip(_ name:String?)->Bool{
        return true;
    }
    
    fileprivate var fileUrl: URL? {
    didSet {
        updateMimeType()
        loadData()
    }
    }
    fileprivate var _mimeType: String?
    fileprivate var _data: Data?
    fileprivate var _fileName: String?
    
    
    open var mimeType: String?{
        return self._mimeType;
    }
    open var data: Data?{
        return self._data;
    }
    open var fileName: String?{
        return self._fileName;
    }
    
    /// Tries to determine the mime type from the fileUrl extension.
    func updateMimeType() {
        if mimeType == nil && fileUrl != nil {
            let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (fileUrl?.pathExtension as NSString?)!, nil);
            let str = UTTypeCopyPreferredTagWithClass(UTI!.takeUnretainedValue(), kUTTagClassMIMEType);
            if (str == nil) {
                _mimeType = "application/octet-stream";
            } else {
                _mimeType = str!.takeUnretainedValue() as String
            }
        }
    }
    
    /// loads the fileUrl into memory.
    func loadData() {
        if let url = fileUrl {
            self._fileName = url.lastPathComponent
//            self._data = NSData.dataWithContentsOfMappedFile(url.path!) as? NSData
//            self._data = NSData(contentsOfMappedFile: url.path!);
            self._data = try? Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe);
        }
    }
    
    /// Initializes a new HTTPUpload Object.
    public override init() {
        super.init()
    }
    
    /** 
        Initializes a new HTTPUpload Object with a fileUrl. The fileName and mimeType will be infered.
    
        - parameter fileUrl: The fileUrl is a standard url path to a file.
    */
    public convenience init(fileUrl: URL) {
        self.init()
        self.fileUrl = fileUrl
        updateMimeType()
        loadData()
    }
    
    /**
    Initializes a new HTTPUpload Object with a data blob of a file. The fileName and mimeType will be infered if none are provided.
    
        - parameter data: The data is a NSData representation of a file's data.
        - parameter fileName: The fileName is just that. The file's name.
        - parameter mimeType: The mimeType is just that. The mime type you would like the file to uploaded as.
    */
    ///upload a file from a a data blob. Must add a filename and mimeType as that can't be infered from the data
    public convenience init(data: Data, fileName: String, mimeType: String) {
        self.init()
        self._data = data
        self._fileName = fileName
        self._mimeType = mimeType
    }
}
