//
//  PCTContactosTableViewController.m
//  iOSPruebaCoreTelephony
//
//  Created by jorgeSV on 06/03/14.
//  Copyright (c) 2014 menus.es. All rights reserved.
//

#import "PCTContactosTableViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PCTContacto.h"
#import "PCTContactoDetalleViewController.h"

@interface PCTContactosTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *arrayContactos;
@property (nonatomic, strong) NSArray *arrayContactosSorted;

@end

@implementation PCTContactosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        _arrayContactos = [[NSMutableArray alloc] init];
        [self getPersonOutOfAddressBook];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationItem setTitle:self.tabBarItem.title];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPersonOutOfAddressBook
{
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {
        DLog(@"Succesful.");
        
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            PCTContacto *person = [[PCTContacto alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            NSString *fullName = @"";
            
            if(firstName)
                fullName = [NSString stringWithFormat:@"%@", firstName];
            
            if(lastName)
            {
                if(fullName.length)
                    fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@", lastName]];
                else
                    fullName = [NSString stringWithFormat:@"%@", lastName];
            }
            
            fullName = [NSString stringWithUTF8String:[fullName UTF8String]];
            
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    //DLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                else if (j==1)
                    person.workEmail = email;
            }
            
            
            ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(contactPerson, kABPersonPhoneProperty));
            int cont = 0;
            
            for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                //mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
                NSString *strPhone = [(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) stringByReplacingOccurrencesOfString:@"XXXXX" withString:@""];
                
                if([self isValidPhoneNumber:strPhone])
                {
                    person.phone = strPhone;
                    cont++;
                }
            }
            
            if(cont)
                [_arrayContactos addObject:person];
        }
    }
    
    CFRelease(addressBook);
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
    _arrayContactosSorted = [_arrayContactos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //_arrayContactosSorted = [_arrayContactos sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (BOOL) isValidPhoneNumber:(NSString*)phone
{
    //NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    /*NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
     NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
     BOOL result = [test evaluateWithObject:phoneNumber];
     return result;*/
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phone length]);
    NSArray *matches = [detector matchesInString:phone options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0)
    {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length)
    {
        // it matched the whole string
        return YES;
    }
    else
    {
        // it only matched partial string
        return NO;
    }
}






















#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _arrayContactosSorted.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
    
    PCTContacto *person = [_arrayContactosSorted objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = person.fullName;
    cell.detailTextLabel.text = person.phone;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCTContacto *contacto = [_arrayContactosSorted objectAtIndex:indexPath.row];
    PCTContactoDetalleViewController *contactoDetalleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactoDetalleVC"];
    [contactoDetalleVC setContactoSeleccionado:contacto];
    [self.navigationController pushViewController:contactoDetalleVC animated:YES];
    
    /*UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Contactos2ContactoDetalleSegue" source:self destination:contactoDetalleVC];
    [self prepareForSegue:segue sender:contacto];*/
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"Contactos2ContactoDetalleSegue"])
    {
        
    }
}


@end
