/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "ResolutionSettingsWindow.h"
#import "ResolutionSetting.h"
#import "AppDelegate.h"
#import "ProjectSettings.h"

@implementation ResolutionSettingsWindow

@synthesize resolutions;

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    predefinedResolutions = [[NSMutableArray alloc] init];
    
    // iOS
    //[predefinedResolutions addObject:[ResolutionSetting settingIPhone]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhoneLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhonePortrait]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhoneRetinaLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhoneRetinaPortrait]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone5Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone5Portrait]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone6Landscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone6Portrait]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone6PlusLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPhone6PlusPortrait]];
    //[predefinedResolutions addObject:[ResolutionSetting settingIPad]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPadLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPadPortrait]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPadRetinaLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingIPadRetinaPortrait]];
    
    // Android
    //[predefinedResolutions addObject:[ResolutionSetting settingAndroidXSmall]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidXSmallLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidXSmallPortrait]];
    //[predefinedResolutions addObject:[ResolutionSetting settingAndroidSmall]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidSmallLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidSmallPortrait]];
    //[predefinedResolutions addObject:[ResolutionSetting settingAndroidMedium]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidMediumLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidMediumPortrait]];
    //[predefinedResolutions addObject:[ResolutionSetting settingAndroidLarge]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidLargeLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidLargePortrait]];
    //[predefinedResolutions addObject:[ResolutionSetting settingAndroidXLarge]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidXLargeLandscape]];
    [predefinedResolutions addObject:[ResolutionSetting settingAndroidXLargePortrait]];
    
    // HTML 5
    //[predefinedResolutions addObject:[ResolutionSetting settingHTML5]];
    //[predefinedResolutions addObject:[ResolutionSetting settingHTML5Landscape]];
    //[predefinedResolutions addObject:[ResolutionSetting settingHTML5Portrait]];
    
    int i = 0;
    for (ResolutionSetting* setting in predefinedResolutions)
    {
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:setting.name action:@selector(addPredefined:) keyEquivalent:@""];
        item.target = self;
        item.tag = i;
        [addPredefinedPopup.menu addItem:item];
        
        i++;
    }
}

typedef NS_ENUM(int8_t, CCBRecalScaleType)
{
    kCCBRecalScaleTypeMinSize = 0,
    kCCBRecalScaleTypeMaxSize,
    kCCBRecalScaleTypeMinScale,
    kCCBRecalScaleTypeMaxScale
};

- (void)recallcScale:(ResolutionSetting*)resolution designResolution:(CGSize)designResolution designResolutionScale:(float)designResolutionScale scaleType:(CCBRecalScaleType)scaleType{
    
    if(scaleType == kCCBRecalScaleTypeMinScale)
    {
        float scale1 = (resolution.height / resolution.resourceScale) / (designResolution.height / designResolutionScale);
        float scale2 = (resolution.width / resolution.resourceScale) / (designResolution.width / designResolutionScale);
        if(scale1<scale2)
        {
            resolution.mainScale = scale1;
            resolution.additionalScale = (resolution.width / resolution.resourceScale / resolution.mainScale) / (designResolution.width / designResolutionScale );
        }
        else
        {
            resolution.mainScale = scale2;
            resolution.additionalScale = (resolution.height / resolution.resourceScale / resolution.mainScale) / (designResolution.height / designResolutionScale);
        }
    }
    else if(scaleType == kCCBRecalScaleTypeMaxScale)
    {
        float scale1 = (resolution.height / resolution.resourceScale) / (designResolution.height / designResolutionScale);
        float scale2 = (resolution.width / resolution.resourceScale) / (designResolution.width / designResolutionScale);
        if(scale1>scale2)
        {
            resolution.mainScale = scale1;
            resolution.additionalScale = (resolution.width / resolution.resourceScale / resolution.mainScale) / (designResolution.width / designResolutionScale );
        }
        else
        {
            resolution.mainScale = scale2;
            resolution.additionalScale = (resolution.height / resolution.resourceScale / resolution.mainScale) / (designResolution.height / designResolutionScale);
        }
    }
    else if((designResolution.width>designResolution.height) == (scaleType == kCCBRecalScaleTypeMinSize))
    {
        resolution.mainScale = (resolution.height / resolution.resourceScale) / (designResolution.height / designResolutionScale);
        resolution.additionalScale =   (resolution.width / resolution.resourceScale / resolution.mainScale) / (designResolution.width / designResolutionScale );
    }
    else
    {
        resolution.mainScale = (resolution.width / resolution.resourceScale) / (designResolution.width / designResolutionScale);
        resolution.additionalScale =   (resolution.height / resolution.resourceScale / resolution.mainScale) / (designResolution.height / designResolutionScale);
    }
}

- (IBAction)recallcScalesMinSize:(id)sender {
    for (ResolutionSetting* resolution in resolutions)
    {
        [self recallcScale:resolution designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth, [AppDelegate appDelegate].projectSettings.designSizeHeight) designResolutionScale:[AppDelegate appDelegate].projectSettings.designResourceScale scaleType:kCCBRecalScaleTypeMinSize];
    }
}

- (IBAction)recallcScalesMaxSize:(id)sender {
    for (ResolutionSetting* resolution in resolutions)
    {
        [self recallcScale:resolution designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth, [AppDelegate appDelegate].projectSettings.designSizeHeight) designResolutionScale:[AppDelegate appDelegate].projectSettings.designResourceScale scaleType:kCCBRecalScaleTypeMaxSize];
    }
}
- (IBAction)recallcScalesMinScale:(id)sender {
    for (ResolutionSetting* resolution in resolutions)
    {
        [self recallcScale:resolution designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth, [AppDelegate appDelegate].projectSettings.designSizeHeight) designResolutionScale:[AppDelegate appDelegate].projectSettings.designResourceScale scaleType:kCCBRecalScaleTypeMinScale];
    }
}
- (IBAction)recallcScalesMaxScale:(id)sender {
    for (ResolutionSetting* resolution in resolutions)
    {
        [self recallcScale:resolution designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth, [AppDelegate appDelegate].projectSettings.designSizeHeight) designResolutionScale:[AppDelegate appDelegate].projectSettings.designResourceScale scaleType:kCCBRecalScaleTypeMaxScale];
    }
}

- (void) copyResolutions:(NSMutableArray *)res
{
    resolutions = [NSMutableArray arrayWithCapacity:[res count]];
    
    for (ResolutionSetting* resolution in res)
    {
        [resolutions addObject:[resolution copy]];
    }
}

- (BOOL) sheetIsValid
{
    if ([resolutions count] > 0)
    {
        return YES;
    }
    else
    {
        // Display warning!
        NSAlert* alert = [NSAlert alertWithMessageText:@"Missing Resolution" defaultButton:@"OK" alternateButton:NULL otherButton:NULL informativeTextWithFormat:@"You need to have at least one valid resolution setting."];
        [alert beginSheetModalForWindow:[self window] modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
        
        return NO;
    }
}

- (void) addPredefined:(id)sender
{
    ResolutionSetting* setting = [predefinedResolutions objectAtIndex:[sender tag]];
    [self recallcScale:setting designResolution:CGSizeMake([AppDelegate appDelegate].projectSettings.designSizeWidth, [AppDelegate appDelegate].projectSettings.designSizeHeight) designResolutionScale:[AppDelegate appDelegate].projectSettings.designResourceScale scaleType:kCCBRecalScaleTypeMaxSize];
    [arrayController addObject:setting];
}


@end
