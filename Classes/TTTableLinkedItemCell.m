//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTableLinkedItemCell.h"

// UI
#import "TTNavigator.h"
#import "TTTableLinkedItem.h"

// UINavigator
#import "TTURLMap.h"

// Style
#import "TTGlobalStyle.h"
#import "TTDefaultStyleSheet.h"

// Core
#import "TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableLinkedItemCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_item);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
  return _item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
  if (_item != object) {
    [_item release];
    _item = [object retain];

    TTTableLinkedItem* item = object;

    if (item.URL) {
      TTNavigationMode navigationMode = [[TTNavigator navigator].URLMap
                                         navigationModeForURL:item.URL];
      if (item.accessoryURL) {
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

      } else if (navigationMode == TTNavigationModeCreate ||
                 navigationMode == TTNavigationModeShare) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

      } else {
        self.accessoryType = UITableViewCellAccessoryNone;
      }

      self.selectionStyle = TTSTYLEVAR(tableSelectionStyle);

    } else {
      self.accessoryType = UITableViewCellAccessoryNone;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  }
}


@end
